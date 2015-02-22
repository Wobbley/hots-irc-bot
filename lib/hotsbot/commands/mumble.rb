require 'rubygems'
require 'cinch'
require 'cinch/commands'

require File.dirname(__FILE__) + '/url_printer'

module Hotsbot
  module Commands
    class Mumble
      include Cinch::Plugin
      include Cinch::Commands

      COMMAND = 'mumble'
      COMMAND_SUMMARY = 'Prints server info of the Reddit Mumble'
      COMMAND_MESSAGE = 'The Reddit community mumble server can be found here: hotsreddit.no-ip.org ; port: 7000'
      include UrlPrinter
    end
  end
end
