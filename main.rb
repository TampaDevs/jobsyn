# frozen_string_literal: true

require 'json'
require 'net/http'

require_relative 'job'
require_relative 'db'
require_relative 'slack'
require_relative 'tweet'

class BoardSyndicator
  attr_accessor :db, :slack, :tweet

  def initialize
    @db = DB.new('./jobs.sqlite')
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
    return if @db.job_exist?(job)

    @slack.syndicate(job)
    @tweet.syndicate(job)

    puts "Syndicated: #{job.title} \##{job.id}"

    @db.add_job(job)
  end
end

boardsyn = BoardSyndicator.new
boardsyn.scan
