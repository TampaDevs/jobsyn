# frozen_string_literal: true

require 'twitter'
require_relative 'twitter_keys'

class Tweet
  attr_accessor :client, :keys, :post_types, :utm_params

  def initialize
    @keys = TwitterKeys.new

    @post_types = ["basic", "promoted", "featured"]

    @utm_params = {
      source: 'tw_tampadevjobs',
      medium: 'social',
      campaign: 'tampadevs_job_board'
    }

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @keys.api_key
      config.consumer_secret     = @keys.api_secret
      config.access_token        = @keys.access_token
      config.access_token_secret = @keys.access_token_secret
    end
  end

  def syndicate(jobs, dry_run: true)
    return if jobs.empty?

    jobs.each do |job|
      next unless @post_types.include? job.type
      @client.update(payload(job)) unless dry_run
      puts payload(job) if dry_run
    end
  end

  def payload(job)
    "#{job.title_summary}\n#{job.arrangement_summary}\n#{job.comp_summary} #{job.link_utm(job.post_link, **@utm_params)}"
  end
end
