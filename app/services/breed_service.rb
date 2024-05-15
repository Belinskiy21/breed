# frozen_string_literal: true

# This is a service for the breed sanitize and fetch
class BreedService
  attr_accessor :input

  def initialize(input)
    @input = input
  end

  def call
    response.ok?
  end

  def breed
    @breed ||= input.split.map(&:capitalize).join(' ')
  end

  def img
    JSON.parse(response.body)['message']
  end

  private

  def sanitized_input
    input.strip.downcase.split.join('/')
  end

  def url
    @url ||= "https://dog.ceo/api/breed/#{sanitized_input}/images/random"
  end

  def response
    @response ||= HTTParty.get(url)
  end
end
