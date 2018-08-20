# frozen_string_literal: true

namespace :shakuro do
  desc 'Launches database migration'
  task :migrate, [:to, :from] do |_task, args|
    require_relative 'config/app_init'

    Shakuro::Init.run!('class_ext', 'logger', 'sequel')
    Shakuro.need 'tasks/migration'

    to = args[:to]
    from = args[:from]
    dir = "#{Shakuro.root}/db/migrations"
    Shakuro::Tasks::Migration.new(to, from, dir).launch!
  end
end
