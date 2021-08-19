# frozen_string_literal: true

require 'zeitwerk'

# Autoload code.
loader = Zeitwerk::Loader.new

loader.push_dir(__dir__)

loader.collapse("#{__dir__}/concerns")
loader.collapse("#{__dir__}/models")
loader.collapse("#{__dir__}/utilities")

loader.do_not_eager_load(__FILE__)
loader.do_not_eager_load("#{__dir__}/models")

begin
  require 'dotenv/load'
rescue LoadError
  nil
end

loader.setup
loader.eager_load