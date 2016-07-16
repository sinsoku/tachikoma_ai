require 'spec_helper'

module TachikomaAi
  module Strategies
    describe Bundler do
      describe '#pull_request_body' do
        let(:bundler) { Bundler.new }
        let(:expected) { 'https://github.com/sinsoku/tachikoma_ai/compare/v0.1.0...v0.2.0' }
        before do
          allow(bundler).to receive(:diff) { ['-    tachikoma_ai (0.1.0)', '+    tachikoma_ai (0.2.0)'] }
          allow_any_instance_of(Bundler::Gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' }
          stub_request(:get, 'https://api.github.com/repos/sinsoku/tachikoma_ai/git/refs/tags')
            .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}, {"ref":"refs/tags/v0.2.0"}]')
        end
        it { expect(bundler.pull_request_body).to include expected }
      end
    end
  end
end
