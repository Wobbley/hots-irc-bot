require File.dirname(__FILE__) + '/../../helper'
require File.dirname(__FILE__) + '/../../../lib/hotsbot/bot_factory'
require File.dirname(__FILE__) + '/../../../lib/utils/configuration'

module Hotsbot
  class BotFactoryTest < TestCase
    def setup
      Hotsbot::Utils::Configuration.load(File.dirname(__FILE__) + '/../../fixtures/test_config.yml')
    end

    def test_create_bot_from_a_file
      bot = BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)

      assert_equal 'foo.example.com', bot.config.server
      assert_equal ['#foo', '#bar'], bot.config.channels
      assert_equal 'foobot', bot.config.nick
    end

    def test_raise_error_if_irc_configuration_is_missing
      exception = assert_raises RuntimeError do
        Hotsbot::Utils::Configuration.config.clear

        BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)
      end
      assert_equal 'IRC configuration is required', exception.message
    end

    def test_raise_error_if_server_is_missing
      exception = assert_raises RuntimeError do
        Hotsbot::Utils::Configuration.config.irc.server = nil

        BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)
      end
      assert_equal 'Server is required', exception.message
    end

    def test_raise_error_if_channels_is_missing
      exception = assert_raises RuntimeError do
        Hotsbot::Utils::Configuration.config.irc.channels = nil

        BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)
      end
      assert_equal 'Channels list is required', exception.message
    end

    def test_raise_error_if_nick_is_missing
      exception = assert_raises RuntimeError do
        Hotsbot::Utils::Configuration.config.irc.nick = nil

        BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)
      end
      assert_equal 'Nick is required', exception.message
    end

    def test_plugins_are_loaded
      bot = BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)

      assert_equal(
        [
          Commands::Battletags,
          Commands::Rotation,
          Commands::Tierlist,
          Commands::Tips,
          Commands::Mumble,
          Commands::Ts,
          Commands::Bug,
          Cinch::Commands::Help,
          Cinch::Plugins::Identify
        ],
        bot.config.plugins.plugins
      )
    end
  end
end
