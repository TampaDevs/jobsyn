# frozen_string_literal: true

require 'twitter'
require_relative 'twitter_keys'

class Tweet
  attr_accessor :client, :keys

  def initialize
    @keys = TwitterKeys.new

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @keys.api_key
      config.consumer_secret     = @keys.api_secret
      config.access_token        = @keys.access_token
      config.access_token_secret = @keys.access_token_secret
    end
  end

  def syndicate(job)
    p
    @client.update(job_summary(job))
  end

  def job_summary(job)
    "#{job.title.gsub(/\w+/, &:capitalize)} at #{job.company_name.gsub(/\w+/, &:capitalize)}. #{job.arrangement.capitalize}, #{job.location.capitalize} (#{job.company_location.capitalize}). #{job.post_link}"
  end
end
