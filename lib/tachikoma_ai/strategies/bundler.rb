require 'tachikoma_ai/strategies/bundler/gem'

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

        names = plus_gems.map(&:name) & minus_gems.map(&:name)
        @updated_gems = plus_gems.select { |g| names.include? g.name }
        @updated_gems.each do |g|
          g.from = minus_gems.find { |mg| mg.name == g.name }.version
        end
        @updated_gems
      end

      def diff
        @diff ||= `git show --format= HEAD`.split("\n")
      end

      def minus_gems
        @minus_gems ||= diff.select { |s| s =~ /^- {4}\S/ }
                            .map { |s| TachikomaAi::Bundler::Gem.parse(s) }
      end

      def plus_gems
        @plus_gems ||= diff.select { |s| s =~ /^\+ {4}\S/ }
                           .map { |s| TachikomaAi::Bundler::Gem.parse(s) }
      end

      def compare_urls
        updated_gems.select(&:github?).map(&:compare_url).join("\n")
      end

      def homepage_urls
        updated_gems.reject(&:github?).map(&:homepage).join("\n")
      end
    end
  end
end
