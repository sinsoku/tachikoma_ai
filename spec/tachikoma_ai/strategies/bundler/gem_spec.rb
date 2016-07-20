require 'spec_helper'

module TachikomaAi
  module Strategies
    class Bundler
      describe Gem do
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
      end
    end
  end
end
