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
      username: @keys.username,
      icon_emoji: @keys.icon,
      channel: @keys.channel,
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: ':star: New post on <https://jobs.tampa.dev|jobs.tampa.dev>:'
          }
        },
        {
          type: 'divider'
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{job.title.gsub(/\w+/, &:capitalize)}* at *#{job.company_name.gsub(/\w+/, &:capitalize)}*\n#{job.arrangement.capitalize}\n#{job.location.capitalize} (#{job.company_location.capitalize})"
          },
          accessory: {
            type: 'image',
            image_url: 'https://www.tampadevs.com/_assets/img/jobs/jobs_square.png',
            alt_text: 'Company Logo'
          }
        },
        {
          type: 'context',
          elements: [
            {
              type: 'mrkdwn',
              text: ':rocket:'
            },
            {
              type: 'mrkdwn',
              text: "<#{job.post_link}|Apply Now>"
            }
          ]
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
