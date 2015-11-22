$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'tachikoma_ai'
require 'tachikoma_ai/strategies/bundler'
