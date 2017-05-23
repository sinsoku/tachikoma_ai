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
          gem(spec, before)
        end.compact.uniq(&:name)
      end

      def diff_specs(previous, current)
        current.specs.reject { |s| previous.specs.include?(s) }
      end

      def lockfile(ref)
        ::Bundler::LockfileParser.new(`git show #{ref}:Gemfile.lock`)
      end

      def compare_urls
        updated_gems.select(&:github_url?).map { |gem| url_with_checkbox(gem.compare_url) }.join("\n")
      end

      def url_with_checkbox(url)
        "- [ ] #{url}"
      end

      def homepage_urls
        updated_gems.reject(&:github_url?).map(&:homepage).join("\n")
      end

      def gem(spec, before)
        return if before.nil?
        Gem.new(spec.name, before.version.to_s, spec.version.to_s)
      end
    end
  end
end
