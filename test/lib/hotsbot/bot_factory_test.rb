require File.dirname(__FILE__) + '/../../helper'
require File.dirname(__FILE__) + '/../../../lib/hotsbot/bot_factory'
require 'app_conf'

class BotFactoryTest < TestCase
  def test_create_bot_from_a_file
    configuration = AppConf.new
    configuration.load(File.dirname(__FILE__) + '/../../fixtures/test_config.yml')

    bot = BotFactory.from_configuration(configuration)

    assert_equal 'foo.example.com', bot.config.server
    assert_equal ['#foo', '#bar'], bot.config.channels
    assert_equal 'foobot', bot.config.nick
  end

  def test_raise_error_if_irc_configuration_is_missing
    exception = assert_raises Exception do
      configuration = AppConf.new

      BotFactory.from_configuration(configuration)
    end
    assert_equal 'IRC configuration is required', exception.message
  end

  def test_raise_error_if_server_is_missing
    exception = assert_raises Exception do
      configuration = AppConf.new
      configuration.irc = AppConf.new
      configuration.irc.server = nil

      BotFactory.from_configuration(configuration)
    end
    assert_equal 'Server is required', exception.message
  end

  def test_raise_error_if_channels_is_missing
    exception = assert_raises Exception do
      configuration = AppConf.new
      configuration.irc = AppConf.new
      configuration.irc.server = 'foo'

      BotFactory.from_configuration(configuration)
    end
    assert_equal 'Channels list is required', exception.message
  end

  def test_raise_error_if_nick_is_missing
    exception = assert_raises Exception do
      configuration = AppConf.new
      configuration.irc = AppConf.new
      configuration.irc.server = 'foo'
      configuration.irc.channels = ['#foo']

      BotFactory.from_configuration(configuration)
    end
    assert_equal 'Nick is required', exception.message
  end
end
