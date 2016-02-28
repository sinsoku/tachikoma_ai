require 'tachikoma_ai/strategy'
require 'tachikoma_ai/tachikoma_extention'
require 'tachikoma_ai/version'

module TachikomaAi
  module Strategies
    autoload :Bundler, 'tachikoma_ai/strategies/bundler'
  end

  def self.strategies
    @strategies ||= []
  end
end

require 'tachikoma/application'
Tachikoma::Application.send :prepend, TachikomaAi::TachikomaExtention
