# frozen_string_literal: true

class Job
  attr_accessor :application_email, :application_url, :arrangement, :company_location, :company_logo, :company_name,
                :expires_at, :location, :published_at, :salary_max, :salary_min, :salary_schedule, :title, :type, :id, :post_link, :post_type

  def initialize(post_json)
    @arrangement = post_json['attributes']['arrangement']
    @location = post_json['attributes']['location']
    @title = post_json['attributes']['title']
    @type = post_json['attributes']['type']

    @application_email = post_json['attributes']['application']['email'] || "jobs@tampadevs.com"
    @application_url = post_json['attributes']['application']['url'] || post_json['links']['self']

    @company_location = post_json['attributes']['company']['location'] || "Location unspecified"
    @company_name = post_json['attributes']['company']['name']
    @company_logo = post_json['attributes']['company']['logo']

    @expires_at = post_json['attributes']['expires_at']
    @published_at = post_json['attributes']['published_at']

    begin
      @salary_max = post_json['attributes']['salary']['maximum']['cents'] / 100.0
      @salary_min = post_json['attributes']['salary']['minimum']['cents'] / 100.0
      @salary_currency = post_json['attributes']['salary']['maximum']['currency_iso'] || "USD"
    rescue
      @salary_max = ""
      @salary_min = ""
      @salary_currency = ""
    end

    @salary_schedule = post_json['attributes']['salary']['schedule'] || "Salary schedule unspecified"


    @id = post_json['id']

    @post_link = post_json['links']['self'] || "https://jobs.tampa.dev/"
    @post_type = post_json['type']
  end

  def title_summary
    "#{@title.gsub(/\w+/, &:capitalize)} at #{@company_name}"
  end

  def arrangement_summary
    arrangement = "#{@arrangement.capitalize}"
    arrangement += ", #{@location.capitalize} " unless @location.capitalize.empty?
    arrangement += "(#{company_location.gsub(/\w+/, &:capitalize)})" unless @company_location.empty?
    arrangement
  end

  def comp_summary
    return "$#{@salary_min.truncate.to_s.reverse.scan(/.{1,3}/).join(',').reverse} - $#{@salary_max.truncate.to_s.reverse.scan(/.{1,3}/).join(',').reverse} #{@salary_currency} #{@salary_schedule.capitalize}" unless @salary_currency.empty?

    ""
  end

  def link_utm(url, source: '', medium: '', campaign: '')
    uri = URI(url)
    
    params = URI.decode_www_form(uri.query || "") << ["utm_source", source]
    params << ["utm_medium", medium]
    params << ["utm_campaign", campaign]

    uri.query = URI.encode_www_form(params)
    uri.to_s
  end
end
