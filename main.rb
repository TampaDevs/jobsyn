# frozen_string_literal: true

require 'json'
require 'net/http'

require_relative 'job'
require_relative 'db'
require_relative 'slack'
require_relative 'tweet'

class BoardSyndicator
  attr_accessor :db, :channels, :dry_run

  def initialize
    @db = DB.new('./jobs.sqlite')
    @channels = [Slack.new]

    @dry_run = true
    @dry_run = false if ENV["SYN_ENV"] == "production"
  end

  def scan
    jobs = JSON.parse(Net::HTTP.get(URI('https://jobs.tampa.dev/jobs.json')))
    new_posts = []

    jobs["data"].each do |jd|
      job = Job.new(jd)

      unless dry_run
        next if @db.job_exist?(job)
        @db.add_job(job)
      end 

      puts "Syndicating: #{job.title} \##{job.id}"

      new_posts.push(job)
    end 

    @channels.each do |chan|
      chan.syndicate(new_posts, dry_run: @dry_run)
      puts "Channel exec: #{chan.class.name}"
    end
  end
end

boardsyn = BoardSyndicator.new
boardsyn.scan
