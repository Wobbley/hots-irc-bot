require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot
  module Commands
    class Ts
      include Cinch::Plugin
      include Cinch::Commands

      command :ts, {},
              aliases: [ :ts3 ],
              summary: 'Prints server info of the Reddit Teamspeak',
              description: 'Prints server info of the Reddit Teamspeak'

      URL = 'ts3.oda-h.com'

      def ts(m)
        m.target.send "The Reddit community TS3 server can be found here: #{URL}"
      end
    end
  end
end
