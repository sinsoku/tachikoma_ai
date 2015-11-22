require 'spec_helper'

module TachikomaAi
  describe TachikomaExtention do
    let(:app) { Tachikoma::Application.new }
    let(:default_body) { ':hamster:' * 3 }

    before do
      # stub each method in the run method except pull_request
      allow(app).to receive(:load)
      allow(app).to receive(:fetch)
      allow(app).to receive(:bundler)

      app.instance_variable_set :@pull_request_body, default_body
      allow_any_instance_of(Strategies::Bundler).to receive(:pull_request_body) { 'body' }
      allow_any_instance_of(Octokit::Client).to receive(:create_pull_request)

      app.run 'bundler'
    end

    it 'should overwrite a pull request body' do
      actual = app.instance_variable_get :@pull_request_body
      expect(actual).to eq "#{default_body}\n\nbody"
    end
  end
end
