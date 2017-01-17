require 'spec_helper'

module TachikomaAi
  module Strategies
    class Bundler
      describe Gem do
        describe '#compare_url' do
          let(:gem) { Gem.new('tachikoma_ai', '0.1.0', '0.2.0') }
          let(:repository) { Repository.new('https://github.com/sinsoku/tachikoma_ai') }
          let(:compare_url) { 'https://github.com/sinsoku/tachikoma_ai/compare/v0.1.0...v0.2.0' }

          context 'the compare url created successfully' do
            before do
              allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' }
              stub_request(:get, repository.send(:api_tags_url))
                .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}, {"ref":"refs/tags/v0.2.0"}]')
            end
            it { expect(gem.compare_url).to eq compare_url }
          end

          context 'failed to create the compare url' do
            before do
              allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' }
              allow_any_instance_of(Repository).to receive(:compare) { raise 'something' }
            end
            it { expect(gem.compare_url).to eq "#{compare_url} (RuntimeError something)" }
          end
        end

        describe '#homepage' do
          context do
            let(:gem) { Gem.new('tachikoma_ai', '0.1.0', '0.2.0') }
            before { allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' } }
            it { expect(gem.homepage).to eq 'https://github.com/sinsoku/tachikoma_ai' }
          end

          context 'when specify a github repository in Gemfile' do
            let(:gem) { Gem.new('tachikoma_ai', '0.1.0', '0.2.0') }
            before { allow(gem).to receive(:spec) { nil } }
            it { expect(gem.homepage).to eq 'tachikoma_ai-0.2.0' }
          end
        end

        describe '#github_url?' do
          context 'gem does not include in URLS' do
            let(:gem) { Gem.new('tachikoma_ai', '0.1.0', '0.2.0') }
            before { allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' } }
            it { expect(gem).to be_github_url }
          end

          context 'gem include in URLS' do
            let(:gem) { Gem.new('sidekiq', '1.0.0', '1.0.1') }
            it { expect(gem).to be_github_url }
          end
        end

        describe 'github_urls.json' do
          it 'sort by gem name' do
            expect(Gem::GITHUB_URL_JSON.keys).to eq Gem::GITHUB_URL_JSON.keys.sort
          end
        end
      end
    end
  end
end
