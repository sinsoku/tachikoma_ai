require 'tachikoma_ai/strategies/bundler/gem'
require 'bundler'

module TachikomaAi
  module Strategies
    class Bundler
      include TachikomaAi::Strategy

      def pull_request_body
        <<-EOF
## Compare
#{compare_urls}

## Not found
#{homepage_urls}
        EOF
      end

      private

      def updated_gems
        return @updated_gems if @updated_gems

        previous = lockfile('HEAD^')
        @updated_gems = diff_specs(previous, lockfile('HEAD')).map do |spec|
          before = previous.specs.find { |s| s.name == spec.name }
          Gem.new(spec.name, before.version.to_s, spec.version.to_s)
        end.uniq(&:name)
      end

      def diff_specs(previous, current)
        current.specs.reject { |s| previous.specs.include?(s) }
      end

      def lockfile(ref)
        ::Bundler::LockfileParser.new(`git show #{ref}:Gemfile.lock`)
      end

      def compare_urls
        updated_gems.select(&:github_url?).map(&:compare_url).join("\n")
      end

      def homepage_urls
        updated_gems.reject(&:github_url?).map(&:homepage).join("\n")
      end
    end
  end
end
