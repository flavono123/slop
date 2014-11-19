module Slop
  # This class encapsulates a Parser and Option pair. The idea is that
  # the Option class shouldn't have to deal with what happens when options
  # are parsed, and the Parser shouldn't have to deal with the state of
  # options once parsing is complete. This keeps the API really simple; A
  # Parser parses, Options handles options, and this class handles the
  # result of those actions. This class contains the important most used
  # methods.
  class Result
    attr_reader :parser, :options

    def initialize(parser)
      @parser  = parser
      @options = parser.options
    end

    # Returns an options value, nil if the option does not exist.
    def [](flag)
      (o = option(flag)) && o.value
    end
    alias get []

    # Returns an Option if it exists. Ignores any prefixed hyphens.
    def option(flag)
      cleaned = -> (f) { f.to_s.sub(/\A--?/, '') }
      options.find do |o|
        o.flags.any? { |f| cleaned.(f) == cleaned.(flag) }
      end
    end

    def method_missing(name, *args, &block)
      if respond_to_missing?(name)
        (o = option(name.to_s.chomp("?"))) && used_options.include?(o)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      name.to_s.end_with?("?") || super
    end

    def used_options
      parser.used_options
    end

    def unused_options
      parser.unused_options
    end

    # Returns a hash with option key => value.
    def to_hash
      Hash[options.map { |o| [o.key, o.value] }]
    end
  end
end
