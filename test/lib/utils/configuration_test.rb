require File.dirname(__FILE__) + '/../../helper'
require File.dirname(__FILE__) + '/../../../lib/utils/configuration'

module Hotsbot
  class ConfigurationTest < TestCase
    def test_can_load_and_configuration_from_file
      Configuration.load(File.dirname(__FILE__) + '/../../fixtures/test_config.yml')

      assert_equal 'foo.example.com', Configuration.config.irc.server
      assert_equal ['#foo', '#bar'], Configuration.config.irc.channels
      assert_equal 'foobot', Configuration.config.irc.nick
    end
  end
end
