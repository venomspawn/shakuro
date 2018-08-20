# frozen_string_literal: true

require 'rspec'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.expose_dsl_globally = false
end

require_relative '../config/app_init'

Shakuro::Init.run!

Dir["#{Shakuro.root}/spec/helpers/**/*.rb"].sort.each(&method(:require))
Dir["#{Shakuro.root}/spec/shared/**/*.rb"].sort.each(&method(:require))
Dir["#{Shakuro.root}/spec/support/**/*.rb"].sort.each(&method(:require))
