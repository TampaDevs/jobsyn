# frozen_string_literal: true

require 'uri'
require 'net/https'
require 'json'
require_relative 'slack_keys'

class Slack
  attr_accessor :keys

  def initialize
    @keys = SlackKeys.new
  end

  def syndicate(job)
    post_webhook(payload(job))
  end

  def payload(job)
    {
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: ':zap: New post on <https://jobs.tampa.dev|jobs.tampa.dev>:'
          }
        },
        {
          type: 'divider'
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{job.title.gsub(/\w+/, &:capitalize)}* at *#{job.company_name.gsub(/\w+/, &:capitalize)}*\n#{job.arrangement_summary}\n#{job.comp_summary}"
          }
        },
        {
          type: 'context',
          elements: [
            {
              type: 'image',
              image_url: 'https://www.tampadevs.com/_assets/img/jobs/jobs_square.png',
              alt_text: 'Tampa Devs Jobs logo'
            },
            {
              type: 'mrkdwn',
              text: "<#{job.post_link_utm(source: 'td_slack', medium: 'organic', campaign: 'td_basic_syndication')}|Apply Now>"
            }
          ]
        },
        {
          type: 'divider'
        }
      ]
    }
  end

  def post_webhook(payload)
    uri = URI.parse(@keys.url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Accept'] = 'application/json'
    request.content_type = 'application/json'
    request.body = payload.to_json

    https.request(request)
  end
end
