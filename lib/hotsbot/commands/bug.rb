require 'rubygems'
require 'cinch'
require 'cinch/commands'

require File.dirname(__FILE__) + '/url_printer'

module Hotsbot
  module Commands
    class Bug
      include Cinch::Plugin
      include Cinch::Commands

      COMMAND = 'bug'
      COMMAND_SUMMARY = "Submit an issue the bot's bug tracker"
      COMMAND_MESSAGE = 'You can submit a bug by creating an issue at this URL: http://github.com/chadrien/hots-irc-bot/issues'
      include UrlPrinter
    end
  end
end
