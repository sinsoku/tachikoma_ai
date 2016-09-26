require 'spec_helper'

module TachikomaAi
  describe Repository do
    describe '#initialize' do
      let(:repository) { Repository.new('https://github.com/sinsoku/tachikoma_ai') }
      it { expect(repository.owner).to eq 'sinsoku' }
      it { expect(repository.repo).to eq 'tachikoma_ai' }
    end

    describe '#compare' do
      let(:repository) { Repository.new('https://github.com/sinsoku/tachikoma_ai') }

      context 'Response: 200 OK ' do
        before do
          stub_request(:get, repository.send(:api_tags_url))
            .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}, {"ref":"refs/tags/v0.2.0"}]')
        end
        subject { repository.compare('0.1.0', '0.2.0') }
        it { is_expected.to eq 'https://github.com/sinsoku/tachikoma_ai/compare/v0.1.0...v0.2.0' }
      end

      context 'Response: 301 Moved Permanently' do
        before do
          redirect_url = 'https://api.github.com/repositories/1/git/refs/tags'
          stub_request(:get, repository.send(:api_tags_url))
            .to_return(status: 301, headers: { 'Location' => redirect_url })
          stub_request(:get, redirect_url)
            .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}, {"ref":"refs/tags/v0.2.0"}]')
        end
        subject { repository.compare('0.1.0', '0.2.0') }
        it { is_expected.to eq 'https://github.com/sinsoku/tachikoma_ai/compare/v0.1.0...v0.2.0' }
      end

      context 'Response: 404 Not Found' do
        before do
          stub_request(:get, repository.send(:api_tags_url))
            .to_return(status: 404, body: '{"message": "Not Found"}')
        end
        subject { repository.compare('0.1.0', '0.2.0') }
        it { is_expected.to eq 'https://github.com/sinsoku/tachikoma_ai/compare/...' }
      end
    end

    describe 'private #find_tag' do
      context 'the version tag with "v" prefix on GitHub' do
        let(:repository) { Repository.new('https://github.com/sinsoku/tachikoma_ai') }
        before do
          stub_request(:get, repository.send(:api_tags_url))
            .to_return(status: 200, body: '[{"ref":"refs/tags/v0.1.0"}]')
        end
        it { expect(repository.send(:find_tag, '0.1.0')).to eq 'v0.1.0' }
      end

      context 'the version tag without "v" prefix on GitHub' do
        let(:repository) { Repository.new('https://github.com/sinsoku/tachikoma_ai') }
        before do
          stub_request(:get, repository.send(:api_tags_url))
            .to_return(status: 200, body: '[{"ref":"refs/tags/0.1.0"}]')
        end
        it { expect(repository.send(:find_tag, '0.1.0')).to eq '0.1.0' }
      end
    end
  end
end
