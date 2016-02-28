require 'spec_helper'

module TachikomaAi
  module Bundler
    describe '.parse' do
      subject { Gem.parse('+    byebug (5.0.0)') }
      it { expect(subject.name).to eq 'byebug' }
      it { expect(subject.version).to eq '5.0.0' }
    end

    describe '#homepage' do
      let(:gem) { Gem.new('tachikoma_ai', '0.1.0') }
      before { allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' } }
      it { expect(gem.homepage).to eq 'https://github.com/sinsoku/tachikoma_ai' }
    end

    describe '#github?' do
      let(:gem) { Gem.new('tachikoma_ai', '0.1.0') }
      before { allow(gem).to receive(:spec_path) { 'tachikoma_ai.gemspec' } }
      it { expect(gem).to be_github }
    end
  end
end
