# frozen_string_literal: true

require 'uri'
require 'net/https'
require 'json'
require_relative 'slack_keys'

class Slack
  attr_accessor :keys, :message, :post_types, :utm_params

  def initialize
    @keys = SlackKeys.new

    @post_types = ["basic", "promoted", "featured"]

    @utm_params = {
      source: 'td_slack',
      medium: 'organic',
      campaign: 'tampadevs_job_board'
    }

    @message = []
  end

  def syndicate(jobs, dry_run: true)
    return if jobs.empty?

    jobs.each do |job|
      next unless @post_types.include? job.type
      @message.concat(payload(job))
    end

    post unless dry_run
    puts message_json if dry_run
  end

  def payload(job)
    job_links = ""
    job_links += "<#{job.link_utm(job.application_url, **@utm_params)}|:rocket: Apply Now>" unless job.application_url.empty?
    job_links += "<#{job.link_utm(job.post_link, **@utm_params)}|:rocket: Apply Now>" if job.application_url.empty?
    job_links += " or <#{job.link_utm(job.post_link, **@utm_params)}|See Description>" unless job.post_link.empty?

    job_text = "*#{job.title.gsub(/\w+/, &:capitalize)}* at *#{job.company_name}*"
    job_text += "\n#{job.arrangement_summary}" unless job.arrangement_summary.empty?
    job_text += "\n#{job.comp_summary}" unless job.comp_summary.empty?

    [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: job_text
          }
        },
        {
          type: 'context',
          elements: [
            {
              type: 'mrkdwn',
              text: job_links
            }
          ]
        }
      ]
  end

  def message_json
    {
      blocks: @message
    }.to_json
  end

  def post
    return if @message.length == 0

    uri = URI.parse(@keys.url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Accept'] = 'application/json'
    request.content_type = 'application/json'
    request.body = {
      blocks: @message
    }.to_json

    https.request(request)
  end
end
