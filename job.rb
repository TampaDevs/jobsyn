# frozen_string_literal: true

class Job
  attr_accessor :application_email, :application_url, :arrangement, :company_location, :company_logo, :company_name,
                :expires_at, :location, :published_at, :salary_max, :salary_min, :salary_schedule, :title, :attribute_type, :id, :post_link, :post_type

  def initialize(post_json)
    @arrangement = post_json['attributes']['arrangement']
    @location = post_json['attributes']['location']
    @title = post_json['attributes']['title']
    @type = post_json['attributes']['type']

    @application_email = post_json['attributes']['application']['email']
    @application_url = post_json['attributes']['application']['url']

    @company_location = post_json['attributes']['company']['location']
    @company_name = post_json['attributes']['company']['name']
    @company_logo = post_json['attributes']['company']['logo']

    @expires_at = post_json['attributes']['expires_at']
    @published_at = post_json['attributes']['published_at']

    @salary_max = post_json['attributes']['salary']['maximum']
    @salary_min = post_json['attributes']['salary']['minimum']
    @salary_schedule = post_json['attributes']['salary']['schedule']

    @id = post_json['id']

    @post_link = post_json['links']['self']
    @post_type = post_json['type']
  end
end
