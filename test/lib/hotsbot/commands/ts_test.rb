require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/ts'

module Hotsbot
  module Commands
    class TsTest < Hotsbot::TestCase
      def test_send_ts_address
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        sut = Ts.new(bot)

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["The Reddit community TS3 server can be found here: #{Ts::URL}"]

        sut.ts(message)

        message.target.verify
      end
    end
  end
end
