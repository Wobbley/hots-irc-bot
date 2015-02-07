require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/battletags'

module Hotsbot::Commands
  class BattletagsTest < Hotsbot::TestCase
    def setup
      bot = Cinch::Bot.new
      bot.loggers.level = :fatal

      @db = MiniTest::Mock.new
      @db.expect :nil?, false
      @db.expect :execute, nil, [String]

      @SUT = Battletags.new(bot, @db)
    end

    def test_create_database_if_not_exists
      bot = Cinch::Bot.new
      bot.loggers.level = :fatal

      db = MiniTest::Mock.new
      db.expect :nil?, false
      db.expect :execute, nil, ['CREATE TABLE IF NOT EXISTS BattleTag (irc text, bnet text)']

      Battletags.new(bot, db)

      db.verify
    end

    def test_can_get_battletag
      battletag = 'foo#1234'
      username = 'foo'

      @db.expect :execute, [[battletag]], ['SELECT bnet FROM BattleTag WHERE irc=? COLLATE NOCASE', [username]]

      message = OpenStruct.new
      message.channel = MiniTest::Mock.new
      message.channel.expect :send, nil, ["#{username}'s BattleTag is #{battletag}"]

      @SUT.getbt(message, username)

      @db.verify
      message.verify
    end

    def test_if_no_battletag_is_found_a_message_says_so
      username = 'foo'
      @db.expect :execute, [], ['SELECT bnet FROM BattleTag WHERE irc=? COLLATE NOCASE', [username]]

      message = OpenStruct.new
      message.channel = MiniTest::Mock.new
      message.channel.expect :send, nil, ["No BattleTag found for #{username}"]

      @SUT.getbt(message, username)

      @db.verify
      message.verify
    end

    def test_if_no_username_is_given_help_message_is_sent
      message = OpenStruct.new
      message.user = MiniTest::Mock.new
      message.user.expect :send, nil, ['A irc username is required, example: "!getbt Ravilan"']

      @SUT.getbt(message)

      @db.verify
      message.verify
    end
  end
end
