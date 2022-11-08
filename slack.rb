# frozen_string_literal: true

require 'uri'
require 'net/https'
require 'json'
require_relative 'slack_keys'

class Slack
  attr_accessor :keys, :message

  def initialize
    @keys = SlackKeys.new

    @message = []
  end

  def syndicate(job)
    @message.concat(payload(job))
  end

  def payload(job)
    [
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
              type: 'mrkdwn',
              text: "<#{job.post_link_utm(source: 'td_slack', medium: 'organic', campaign: 'td_basic_syndication')}|:rocket: Apply Now>"
            }
          ]
        }
      ]
  end

  def post
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
