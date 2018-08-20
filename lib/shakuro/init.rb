# frozen_string_literal: true

require 'set'
require 'singleton'

require_relative 'settings/configurable'

module Shakuro
  # Class of application initialization system. Allows to provide a path to
  # directory with initialization files and load some or all of them. Supposes
  # that initialization file names have `<no>_<name>.rb` format, where `<no>`
  # is ASCII-string of length of 2, and loads the files sorted by their full
  # name.
  # @example
  # Let there are  initialization files in directory `config/initializers` with
  # the following names:
  #
  # ```
  # config/
  #   initializers/
  #     01_class_ext.rb
  #     02_sequel.rb
  #     03_rest.rb
  # ```
  #
  # Then in file `config/app_init.rb` the directory can be provided as the
  # following:
  #
  # ```
  # Shakuro::Init.configure do |settings|
  #   settings.set :initializers, "#{__dir__}/initializers"
  # end
  # ```
  # If initialization files `01_class_ext.rb` and `02_sequel.rb` are to be
  # loaded then the following can be invoked:
  #
  # ```
  # Shakuro::Init.run!('class_ext', 'sequel')
  # ```
  # But the same can be done via
  #
  # ```
  # Shakuro::Init.run!('sequel', 'class_ext')
  # ```
  # as the files will be loaded in proper order.
  #
  # If all these initialization files are to be loaded then the function `run!`
  # should be called without arguments:
  # ```
  # Shakuro::Init.run!
  # ```
  class Init
    extend  Settings::Configurable
    include Singleton

    settings_names :initializers, :root, :logger

    # Initializes instance
    def initialize
      @mutex = Thread::Mutex.new
    end

    # Launches files loading if it hasn't been done
    # @param [Array] names
    #   array of initialization names
    def self.run!(names = [])
      instance.run!(names)
    end

    # Launches files loading if it hasn't been done
    # @param [Array] names
    #   array of initialization names
    def run!(names)
      return if initialized?
      mutex.synchronize do
        return if initialized?
        initialized!
      end
      load_initializers(names)
    end

    private

    # Object of loading launch synchronization
    # @return [Thread::Mutex]
    #   synchronization object
    attr_reader :mutex

    # Returns if loading has been launched
    # @return [Boolean]
    #   if loading has been launched
    def initialized?
      @initialized
    end

    # Marks that loading has been launched
    def initialized!
      @initialized = true
    end

    # Returns an array of full paths to initialization files
    # @return [Array<String>]
    #   array of full paths to initialization files
    def paths
      Dir["#{Init.settings.initializers}/*.rb"]
    end

    # Regular expression for initialization file name parts extracting
    NAME_REGEXP = %r{\/.{2}_([^\/]*)\.rb\z}

    # Returns an array of full paths to initialization files with provided
    # names
    # @param [Array] names
    #   array of initialization names
    # @return [Array]
    #   array of full paths to initialization files with provided names
    def filtered_paths(names)
      paths.each_with_object([]) do |path, memo|
        name = NAME_REGEXP.match(path)&.[](1) || next
        memo << path if names.empty? || names.include?(name)
      end
    end

    # Launches files loading
    # @param [Array] names
    #   array of initialization names
    def load_initializers(names)
      filtered_paths(names).sort.each(&method(:require))
    end
  end
end
