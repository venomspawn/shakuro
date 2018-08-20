# frozen_string_literal: true

module Shakuro
  need 'helpers/log'

  # Namespace of objects used for Rake-tasks
  module Tasks
    # Class of objects, which launch database migrations
    class Migration
      include Helpers::Log

      # Launches database migration
      # @param [NilClass, Integer] to
      #   number of target migration. If equals `nil`, last available
      #   migration's number is used.
      # @param [NilClass, Integer] from
      #   number of source migration. If equals `nil`, current migration's
      #   number is used.
      # @param [String] dir
      #   full path to directory with migration files
      def self.launch!(to, from, dir)
        new(to, from, dir).launch!
      end

      # Number of target migration or `nil`
      # @return [NilClass, Integer]
      #   number of target migration or `nil`
      attr_reader :to

      # Number of source migration or `nil`
      # @return [NilClass, Integer]
      #   number of source migration or `nil`
      attr_reader :from

      # Full path to directory with migration files
      # @return [String]
      #   full path to directory with migration files
      attr_reader :dir

      # Initializes instance
      # @param [NilClass, Integer] to
      #   number of target migration. If equals `nil`, last available
      #   migration's number is used.
      # @param [NilClass, Integer] from
      #   number of source migration. If equals `nil`, current migration's
      #   number is used.
      # @param [String] dir
      #   full path to directory with migration files
      def initialize(to, from, dir)
        @to = to
        @from = from
        @dir = dir
      end

      # Launches database migration
      def launch!
        log_start

        options = { current: from&.to_i, target: to&.to_i }
        Sequel::Migrator.run(Sequel::Model.db, dir, options)

        log_finish
      end

      # Logs start of database migration
      def log_start
        log_info { <<-LOG }
          Migration of #{Sequel::Model.db.opts[:database]} has been started
        LOG

        log_info { "Source: #{from || 'current'}, target: #{to || 'last'}" }
      end

      # Logs finish of database migration
      def log_finish
        log_info { <<-LOG }
          Migration of #{Sequel::Model.db.opts[:database]} is finished
        LOG
      end
    end
  end
end
