# frozen_string_literal: true

require_relative 'shakuro/init'

# Root namespace
module Shakuro
  # Returns full path to the root directory
  # @return [#to_s]
  #   full path to the root directory
  def self.root
    Init.settings.root
  end

  # Returns application logger
  # @return [Logger]
  #   application logger
  def self.logger
    Init.settings.logger
  end

  # Returns full path to the directory with source files
  # @return [#to_s]
  #   full path to the directory with source files
  def self.lib
    @lib ||= "#{__dir__}/#{name}"
  end

  # Returns name of the service
  # @return [String]
  #   name of the service
  def self.name
    @name ||= to_s.downcase
  end

  # Value of `RACK_ENV` environment variable meaning development environment
  DEVELOPMENT = 'development'

  # Value of `RACK_ENV` environment variable meaning test environment
  TEST = 'test'

  # Value of `RACK_ENV` environment variable meaning production environment
  PRODUCTION = 'production'

  # List of supported values of `RACK_ENV` environment variable
  ENVIRONMENTS = [DEVELOPMENT, TEST, PRODUCTION].freeze

  # Returns value of `RACK_ENV` environment variable or value of {DEVELOPMENT}
  # constant if value of `RACK_ENV` environment variable is absent or not
  # supported
  # @return [String]
  #   result value
  def self.env
    value = ENV['RACK_ENV']
    ENVIRONMENTS.include?(value) ? value : DEVELOPMENT
  end

  # Returns if application is in development environment
  # @return [Boolean]
  #   if application is in development environment
  def self.development?
    env == DEVELOPMENT
  end

  # Returns if application is in test environment
  # @return [Boolean]
  #   if application is in test environment
  def self.test?
    env == TEST
  end

  # Returns if application is in production environment
  # @return [Boolean]
  #   if application is in production environment
  def self.production?
    env == PRODUCTION
  end

  # Extension of Ruby source files
  RB_EXT = '.rb'

  # Empty list
  EMPTY = [].freeze

  # List for skipping exceptions of `StandardError` class
  SKIP_STANDARD_ERROR = [StandardError].freeze

  # Loads Ruby source files, looking for them in {lib} directory by provided
  # path mask. Doesn't raise exceptions if files aren't found.
  # @example
  #   need 'init' - loads `init.rb` in {lib} directory
  # @example
  #   need 'models/**/*' - loads all Ruby source files in subdirectories (and
  #   sub-subdirectories, and so on) of `models` subdirectory of {lib}
  #   directory
  # @param [#to_s] mask
  #   path mask for source files
  # @param [NilClass, Hash] opts
  #   associative array of loading options or `nil` if no options are provided.
  #   The following keys are supported:
  #   *   `:skip_errors`. Value of the key is used to form a list of exception
  #       classes which are muted during source file loading. The value can be
  #       a class, an array or boolean `true`. For latter value
  #       {SKIP_STANDARD_ERROR} list is used. For any other value empty list is
  #       used (meaning no exception would be muted).
  def self.need(mask, opts = nil)
    mask = mask.to_s
    mask = "#{mask}.rb" unless mask.end_with?(RB_EXT)
    skip_errors = opts[:skip_errors] if opts.is_a?(Hash)
    skip = case skip_errors
           when Class     then [skip_errors]
           when Array     then skip_errors
           when TrueClass then SKIP_STANDARD_ERROR
           else                EMPTY
           end
    Dir["#{lib}/#{mask}"].each { |path| require_file(path, skip) }
  end

  # Loads Ruby source file by provided path. Mutes exceptions raised during
  # loading if their class ancestors belong to the provided list.
  # @param [#to_s] path
  #   source file path
  # @param [#include?] skip
  #   set of exception classes
  def self.require_file(path, skip = EMPTY)
    require path.to_s
  rescue StandardError => error
    raise error if error.class.ancestors.find(&skip.method(:include?)).nil?
  end
end
