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
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ["The Reddit community mumble server can be found here: #{Mumble::URL}"]

        sut.mumble(message)

        message.channel.verify
      end
    end
  end
end
