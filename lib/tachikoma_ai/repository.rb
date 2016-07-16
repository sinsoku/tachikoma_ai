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
      "https://github.com/#{owner}/#{repo}/compare/#{s}...#{e}"
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

      res = Net::HTTP.get_response URI.parse(api_tags_url)
      json = JSON.parse(res.body)
      @tags = json.map { |tag| tag['ref'].gsub('refs/tags/', '') }
    end
  end
end