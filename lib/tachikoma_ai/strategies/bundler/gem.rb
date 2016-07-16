require 'rubygems'
require 'json'

module TachikomaAi
  class Bundler
    class Gem
      STRING_PATTERN = /[-|\+]\s+(\S+)\s\((.+?)\)/
      major, minor = RUBY_VERSION.split('.')
      SPECS_PATH = "vendor/bundle/ruby/#{major}.#{minor}.0/specifications/".freeze
      URLS = JSON.parse(File.read(File.expand_path('urls.json', __dir__)))

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

      def github_url?
        !github_url.nil?
      end

      def github_url
        if URLS.key?(name)
          URLS[name]
        elsif homepage && homepage.include?('github')
          homepage
        end
      end

      def homepage
        @homepage ||= spec.homepage
      end

      def compare_url
        GitHub.new(github_url).compare_url(from, version)
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
