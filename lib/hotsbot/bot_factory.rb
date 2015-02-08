require 'rubygems'
require 'cinch'
require 'yaml'

require File.dirname(__FILE__) + '/commands/tips'
require File.dirname(__FILE__) + '/commands/battletags'

module Hotsbot
  class BotFactory
    def self.from_configuration(configuration)
      guard_against_missing_configuration(configuration)

      Cinch::Bot.new do
        configure do |c|
          c.server = configuration.irc.server
          c.channels = configuration.irc.channels
          c.nick = configuration.irc.nick
          c.plugins.plugins = [
            Commands::Tips,
            Commands::Battletags,
            Commands::Ts,
            Commands::Bug,
            Cinch::Commands::Help
          ]
        end
      end
    end

    private
    def self.guard_against_missing_configuration(configuration)
      raise 'IRC configuration is required' if configuration.irc.nil?

      required_configurations = {
        server: 'Server is required',
        channels: 'Channels list is required',
        nick: 'Nick is required'
      }
      required_configurations.each_pair do |configuration_key, error_message|
        raise error_message if configuration.irc[configuration_key].nil?
      end
    end
  end
end
