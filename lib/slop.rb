require 'slop/option'
require 'slop/options'
require 'slop/parser'
require 'slop/result'
require 'slop/types'
require 'slop/error'

module Slop
  VERSION = '4.0.0'

  def self.parse(items = ARGV, **config, &block)
    Options.new(config, &block).parse(items)
  end

  def self.option_defined?(name)
    const_defined?(string_to_option(name.to_s))
  end

  def self.string_to_option(s)
    s.gsub(/(?:^|_)([a-z])/) { $1.capitalize } + "Option"
  end

  def self.string_to_option_class(s)
    const_get(string_to_option(s))
  end
end
