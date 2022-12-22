# frozen_string_literal: true

class TwitterKeys
  attr_reader :api_key, :api_secret, :bearer_token, :access_token, :access_token_secret, :client_id, :client_secret

  def initialize
    @api_key = ENV["TW_TDJOBS_APIKEY"]
    @api_secret = ENV["TW_TDJOBS_APISECRET"]
    @bearer_token = ENV["TW_TDJOBS_APIBEARER"]
    @access_token = ENV["TW_TDJOBS_ACTOKEN"]
    @access_token_secret = ENV["TW_TDJOBS_ACSECRET"]
    @client_id = ENV["TW_TDJOBS_CLIENTID"]
    @client_secret = ENV["TW_TDJOBS_CLIENTSECRET"]
  end
end
