# frozen_string_literal: true

require 'json'
require 'net/http'

require_relative 'job'
require_relative 'db'
require_relative 'slack'
require_relative 'tweet'

class BoardSyndicatorTest
  attr_accessor :db, :slack, :tweet

  def initialize
    @slack = Slack.new
    @tweet = Tweet.new
  end

  def scan
    jobs = JSON.parse(Net::HTTP.get(URI('https://jobs.tampa.dev/jobs.json')))

    jobs['data'].each do |job|
      syndicate(Job.new(job))
    end
  end

  def syndicate(job)
    p @tweet.job_summary(job)
    p @slack.payload(job).to_json
  end
end

boardsyn = BoardSyndicatorTest.new
boardsyn.scan
