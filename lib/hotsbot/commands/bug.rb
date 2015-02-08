require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot
  module Commands
    class Bug
      include Cinch::Plugin
      include Cinch::Commands

      command :bug, {}, summary: "Submit an issue the bot's bug tracker"

      URL = 'https://github.com/chadrien/hots-irc-bot/issues'

      def bug(m)
        m.target.send "You can submit a bug by creating an issue at this URL: #{URL}"
      end
    end
  end
end
