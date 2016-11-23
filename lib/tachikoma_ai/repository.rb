require 'net/http'
require 'json'

module TachikomaAi
  class Repository
    attr_reader :url, :owner, :repo

    def initialize(url)
      @url = url.gsub(/http:/, 'https:')
      @owner, @repo = URI.parse(@url).path.split('/').drop(1)
    end

    def compare(start, endd)
      s = find_tag(start)
      e = find_tag(endd)
      base = "https://github.com/#{owner}/#{repo}"
      if s.nil? && e.nil?
        "#{base} (tags not found)"
      elsif e.nil?
        "#{base}/compare/#{s}...master"
      else
        "#{base}/compare/#{s}...#{e}"
      end
    end

    private

    def api_tags_url
      "https://api.github.com/repos/#{owner}/#{repo}/git/refs/tags"
    end

    def find_tag(tag)
      tags.find { |t| t == "v#{tag}" || t == tag }
    end

    def tags
      return @tags if @tags

      res = fetch(api_tags_url)
      @tags = if res.is_a? Net::HTTPSuccess
                json = JSON.parse(res.body)
                json.map { |tag| tag['ref'].gsub('refs/tags/', '') }
              else
                {}
              end
    end

    def fetch(uri_str, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit.zero?

      response = Net::HTTP.get_response URI.parse(uri_str)
      if response.is_a? Net::HTTPRedirection
        fetch(response['location'], limit - 1)
      else
        response
      end
    end
  end
end
