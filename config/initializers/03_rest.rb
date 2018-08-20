# frozen_string_literal: true

Shakuro.need 'api/rest/controller'
Shakuro.need 'api/rest/logger'
Shakuro.need 'api/rest/**/*'

Shakuro::API::REST::Controller.configure do |settings|
  settings.set :bind, ENV['SHAKURO_BIND_HOST']
  settings.set :port, ENV['SHAKURO_PORT']

  settings.disable :show_exceptions
  settings.disable :dump_errors
  settings.enable  :raise_errors

  settings.use Shakuro::API::REST::Logger

  settings.enable :static
  settings.set    :root, Shakuro.root
end

Shakuro::API::REST::Controller.configure :production do |settings|
  settings.set :server, :puma
end
