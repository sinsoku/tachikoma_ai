require 'rubygems'

module TachikomaAi
  module Bundler
    class Gem
      STRING_PATTERN = /[-|\+]\s+(\S+)\s\((.+?)\)/
      major, minor = RUBY_VERSION.split('.')
      SPECS_PATH = "vendor/bundle/ruby/#{major}.#{minor}.0/specifications/"

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
        File.join homepage, 'compare', "v#{from}...v#{version}"
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
