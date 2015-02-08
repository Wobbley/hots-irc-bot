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
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ["You can submit a bug by creating an issue at this URL: #{Bug::URL}"]

        sut.bug(message)

        message.channel.verify
      end
    end
  end
end
