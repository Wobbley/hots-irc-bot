require File.dirname(__FILE__) + '/../../helper'
require File.dirname(__FILE__) + '/../../../lib/hotsbot/bot_factory'

module Hotsbot
  class BotFactoryTest < TestCase
    def setup
      Configuration.load(File.dirname(__FILE__) + '/../../fixtures/test_config.yml')
    end

    def test_create_bot_from_a_file
      bot = BotFactory.from_configuration

      assert_equal 'foo.example.com', bot.config.server
      assert_equal ['#foo', '#bar'], bot.config.channels
      assert_equal 'foobot', bot.config.nick
    end

    def test_raise_error_if_irc_configuration_is_missing
      exception = assert_raises Exception do
        Configuration.config.clear

        BotFactory.from_configuration
      end
      assert_equal 'IRC configuration is required', exception.message
    end

    def test_raise_error_if_server_is_missing
      exception = assert_raises Exception do
        Configuration.config.irc.server = nil

        BotFactory.from_configuration
      end
      assert_equal 'Server is required', exception.message
    end

    def test_raise_error_if_channels_is_missing
      exception = assert_raises Exception do
        Configuration.config.irc.channels = nil

        BotFactory.from_configuration
      end
      assert_equal 'Channels list is required', exception.message
    end

    def test_raise_error_if_nick_is_missing
      exception = assert_raises Exception do
        Configuration.config.irc.nick = nil

        BotFactory.from_configuration
      end
      assert_equal 'Nick is required', exception.message
    end

    def test_plugins_are_loaded
      bot = BotFactory.from_configuration

      assert_equal [Commands::Tips, Commands::Battletags, Cinch::Commands::Help], bot.config.plugins.plugins
    end
  end
end
