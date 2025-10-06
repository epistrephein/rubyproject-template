# frozen_string_literal: true

require "zeitwerk"

class Loader
  PUSH               = [__dir__].freeze
  EAGER_LOAD         = true
  EXCLUDE_EAGER_LOAD = %w[models].freeze
  COLLAPSE           = %w[concerns models utilities].freeze
  TRY_REQUIRE        = %w[dotenv/load].freeze

  class << self
    def load!(**opts)
      @loader = Zeitwerk::Loader.new
      @opts   = opts

      push!
      collapse!
      @loader.setup

      try_require!

      exclude_eager_load!
      @loader.eager_load if eager_load?
    end

    private

    def push!
      paths = @opts.fetch(:push, PUSH)
      paths.each { |path| @loader.push_dir(path) }
    end

    def collapse!
      paths = @opts.fetch(:collapse, COLLAPSE)
      paths.each { |path| @loader.collapse("#{__dir__}/#{path}") }
    end

    def try_require!
      gems = @opts.fetch(:try_require, TRY_REQUIRE)
      gems.each do |gem|
        require gem
      rescue LoadError
        next
      end
    end

    def exclude_eager_load!
      paths = @opts.fetch(:exclude_eager_load, EXCLUDE_EAGER_LOAD)
      paths.each { |path| @loader.do_not_eager_load("#{__dir__}/#{path}") }
    end

    def eager_load?
      @opts.fetch(:eager_load, EAGER_LOAD)
    end
  end
end
