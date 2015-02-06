require 'rubygems'
require 'cinch'
require 'yaml'

require File.dirname(__FILE__) + '/commands/tips'

module Hotsbot
  class BotFactory
    def self.from_configuration
      configuration = Configuration.config
      guard_against_missing_configuration(configuration)

      Cinch::Bot.new do
        configure do |c|
          c.server = configuration.irc.server
          c.channels = configuration.irc.channels
          c.nick = configuration.irc.nick
          c.plugins.plugins = [Tips, Cinch::Commands::Help]
        end
      end
    end

    private
    def self.guard_against_missing_configuration(configuration)
      raise Exception, 'IRC configuration is required' if configuration.irc.nil?
      raise Exception, 'Server is required' if configuration.irc.server.nil?
      raise Exception, 'Channels list is required' if configuration.irc.channels.nil?
      raise Exception, 'Nick is required' if configuration.irc.nick.nil?
    end
  end
end
