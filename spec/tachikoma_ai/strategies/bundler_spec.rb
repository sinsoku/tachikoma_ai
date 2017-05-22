require 'spec_helper'

module TachikomaAi
  module Strategies
    describe Bundler do
      describe '#pull_request_body' do
        let(:bundler) { Bundler.new }

        before do
          allow(bundler).to receive(:lockfile).and_return(previous, current)
          allow_any_instance_of(Bundler::Gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' }
          stub_request(:get, 'https://api.github.com/repos/sinsoku/tachikoma_ai/git/refs/tags')
            .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}, {"ref":"refs/tags/v0.2.0"}]')
        end

        context 'when successful' do
          let(:expected) { 'https://github.com/sinsoku/tachikoma_ai/compare/v0.1.0...v0.2.0' }

          let(:previous) { ::Bundler::LockfileParser.new("GEM\n  specs:\n    tachikoma_ai (0.1.0)") }
          let(:current) { ::Bundler::LockfileParser.new("GEM\n  specs:\n    tachikoma_ai (0.2.0)") }

          it { expect(bundler.pull_request_body).to include expected }
        end

        context 'when unsuccessful' do
          let(:expected) { 'activesupport' }
          let(:previous) do
            ::Bundler::LockfileParser.new(
              "GEM\n  specs:\n    activesupport (4.2.6)\n      i18n (~> 0.7)"
            )
          end
          let(:current) do
            ::Bundler::LockfileParser.new(
              "GEM\n  specs:\n    activesupport (5.1.1)\n      concurrent-ruby (~> 1.0, >= 1.0.2)"
            )
          end

          it { expect(bundler.pull_request_body).not_to include expected }
        end
      end
    end
  end
end
