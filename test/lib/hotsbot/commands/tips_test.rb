require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/tips'

module Hotsbot
  module Commands
    class TipsTest < Hotsbot::TestCase
      def setup
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        @SUT = Tips.new(bot)
      end

      def test_send_tips
        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["Tips can be found here: #{Tips::URL}"]

        @SUT.tips(message)

        message.target.verify
      end

      def test_send_tips_to_user
        username = 'foo'
        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["You can find some great tips here, #{username}: #{Tips::URL}"]

        @SUT.tips(message, username)

        message.target.verify
      end
    end
  end
end
