require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/help'

module Hotsbot
  module Commands
    class HelpTest < Hotsbot::TestCase
      def test_send_help
        bot = Cinch::Bot.new do
          configure do |c|
            c.plugins.plugins = [Help]
          end
        end
        bot.loggers.level = :fatal

        message = OpenStruct.new
        message.user = MiniTest::Mock.new
        message.user.expect :send, nil, ['help COMMAND - Displays help information for the COMMAND']
        message.user.expect :send, nil, ['help - Lists available commands']

        Help.new(bot).help(message)

        message.user.verify
      end

      def test_can_get_help_for_a_specific_command
        bot = Cinch::Bot.new do
          configure do |c|
            c.plugins.plugins = [Help]
          end
        end
        bot.loggers.level = :fatal

        message = OpenStruct.new
        message.user = MiniTest::Mock.new
        message.user.expect :send, nil, ['help COMMAND']
        message.user.expect :send, nil, ['help']
        message.user.expect :send, nil, ['']
        message.user.expect :send, nil, ["\n                Finds the COMMAND and prints the usage and description for the\n                COMMAND.\n              "]

        Help.new(bot).help(message, 'help')

        message.user.verify
      end
    end
  end
end
