require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot
  module Commands
    class Mumble
      include Cinch::Plugin
      include Cinch::Commands

      command :mumble, {}, summary: 'Prints server info of the Reddit Mumble'

      URL = 'ts3.oda-h.com'

      def mumble(m)
        m.target.send "The Reddit community mumble server can be found here: #{URL}"
      end
    end
  end
end
