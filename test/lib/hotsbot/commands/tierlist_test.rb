require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/tierlist'

module Hotsbot
  module Commands
    class TierlistTest < Hotsbot::TestCase
      def test_send_tierlist
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        sut = Tierlist.new(bot)

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, [Tierlist::URL]

        sut.tierlist(message)

        message.target.verify
      end
    end
  end
end
