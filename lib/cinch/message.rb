module Cinch
  class Message
    alias_method :parse_params_without_strip, :parse_params

    def parse_params(raw_params)
      parse_params_without_strip(raw_params.strip)
    end
  end
end
