require 'rubygems'
require 'net/http'
require 'json'

module TachikomaAi
  module Bundler
    class Gem
      STRING_PATTERN = /[-|\+]\s+(\S+)\s\((.+?)\)/
      major, minor = RUBY_VERSION.split('.')
      SPECS_PATH = "vendor/bundle/ruby/#{major}.#{minor}.0/specifications/".freeze

      attr_reader :name, :version
      attr_accessor :from

      def self.parse(s)
        m = s.match STRING_PATTERN
        new m[1], m[2]
      end

      def initialize(name, version)
        @name = name
        @version = version
      end

      def github?
        homepage && homepage.include?('github')
      end

      def homepage
        @homepage ||= spec.homepage
      end

      def compare_url
        before_tag = tags.find { |tag| tag == "v#{from}" || tag == from }
        after_tag = tags.find { |tag| tag == "v#{version}" || tag == version }
        File.join homepage, 'compare', "#{before_tag}...#{after_tag}"
      end

      def tags
        return @tags if @tags

        owner, repo = URI.parse(homepage).path.split('/').drop(1)
        url = "https://api.github.com/repos/#{owner}/#{repo}/git/refs/tags"
        res = Net::HTTP.get_response URI.parse(url)
        json = JSON.parse(res.body)
        @tags = json.map { |tag| tag['ref'].gsub('refs/tags/', '') }
      end

      private

      def spec
        ::Gem::Specification.load(spec_path)
      end

      def spec_path
        "#{SPECS_PATH}/#{name}-#{version}.gemspec"
      end
    end
  end
end
