# frozen_string_literal: true

class SlackKeys
  attr_reader :url, :username, :icon, :channel, :channel_admins

  def initialize
    @url = ENV["TD_SLACK_WEBHOOK"]
    @username = 'JobBoardBot'
    @icon = ':star:'
    @channel = 'C02F3C0405A'
    @channel_admins = %w[U03BUP1HE9Z U02D7LW956V] # me, vincent
  end
end
