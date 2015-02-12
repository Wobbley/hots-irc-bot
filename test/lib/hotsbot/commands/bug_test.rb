require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/bug'

module Hotsbot
  module Commands
    class BugTest < Hotsbot::TestCase
      def test_send_bug
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        sut = Bug.new(bot)

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, [Bug::COMMAND_MESSAGE]

        sut.bug(message)

        message.target.verify
      end
    end
  end
end
