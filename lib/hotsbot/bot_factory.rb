require 'rubygems'
require 'cinch'
require 'cinch/plugins/identify'
require 'yaml'

require File.dirname(__FILE__) + '/commands/tips'
require File.dirname(__FILE__) + '/commands/battletags'
require File.dirname(__FILE__) + '/commands/mumble'
require File.dirname(__FILE__) + '/commands/ts'
require File.dirname(__FILE__) + '/commands/bug'
require File.dirname(__FILE__) + '/commands/tierlist'
require File.dirname(__FILE__) + '/commands/rotation'

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
            Commands::Battletags,
            Commands::Rotation,
            Commands::Tierlist,
            Commands::Tips,
            Commands::Mumble,
            Commands::Ts,
            Commands::Bug,
            Cinch::Commands::Help
          ]

          unless configuration.irc.password.nil?
            c.plugins.plugins.push Cinch::Plugins::Identify
            c.plugins.options[Cinch::Plugins::Identify] = {
              username: configuration.irc.nick,
              password: configuration.irc.password,
              type: :quakenet,
            }
          end
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
