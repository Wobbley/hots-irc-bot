require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/mumble'

module Hotsbot
  module Commands
    class MumbleTest < Hotsbot::TestCase
      def test_send_mumble_address
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        sut = Mumble.new(bot)

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, [Mumble::COMMAND_MESSAGE]

        sut.mumble(message)

        message.target.verify
      end
    end
  end
end
