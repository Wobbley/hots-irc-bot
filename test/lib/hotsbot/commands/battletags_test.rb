require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/battletags'

module Hotsbot
  module Commands
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
        db.expect :execute, nil, ['CREATE TABLE IF NOT EXISTS Battletags (nick text, battletag text, region text)']

        Battletags.new(bot, db)

        db.verify
      end

      def test_can_get_battletag
        battletag = 'foo#1234'
        username = 'foo'
        region = 'EU'

        @db.expect :execute, [[battletag, region]], ['SELECT battletag, region FROM Battletags WHERE nick=? COLLATE NOCASE', [username]]

        message = OpenStruct.new
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ["#{username}'s BattleTag is [#{region}]#{battletag}"]

        @SUT.getbt(message, username)

        @db.verify
        message.verify
      end

      def test_if_no_battletag_is_found_a_message_says_so
        username = 'foo'
        @db.expect :execute, [], ['SELECT battletag, region FROM Battletags WHERE nick=? COLLATE NOCASE', [username]]

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
        message.user.expect :send, nil, ['A IRC username is required, example: !getbt Username']

        @SUT.getbt(message)

        @db.verify
        message.verify
      end

      def test_can_add_a_battletag
        username = 'foo'
        battletag = 'test#1234'
        region = 'EU'

        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        db = SQLite3::Database.new ':memory:'

        sut = Battletags.new(bot, db)

        message = OpenStruct.new
        message.user = OpenStruct.new
        message.user.nick = username
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ['BattleTag added']

        sut.addbt(message, battletag, region)

        message.verify
        assert_equal(
          [battletag, region],
          db.execute('SELECT battletag, region FROM Battletags WHERE nick=?', [username]).first
        )

        db.execute('DELETE FROM Battletags')
      end

      def test_addbt_send_a_message_if_no_parameters_are_given
        message = OpenStruct.new
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ['A BattleTag and region are required, example: !addbt Username#1234 EU']

        @SUT.addbt(message)

        message.verify
      end

      def test_addbt_update_if_entry_already_exists
        username = 'foo'
        battletag = 'test#1234'
        battletag2 = 'test#4321'
        region = 'EU'

        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        db = SQLite3::Database.new ':memory:'

        sut = Battletags.new(bot, db)

        message = OpenStruct.new
        message.user = OpenStruct.new
        message.user.nick = username
        message.channel = MiniTest::Mock.new

        message.channel.expect :send, nil, ['BattleTag added']
        sut.addbt(message, battletag, region)

        message.channel.expect :send, nil, ['BattleTag updated']
        sut.addbt(message, battletag2, region)

        message.verify
        assert_equal(
          [battletag2, region],
          db.execute('SELECT battletag, region FROM Battletags WHERE nick=?', [username]).first
        )

        db.execute('DELETE FROM Battletags')
      end

      def test_can_remove_a_battletag
        username = 'foo'

        message = OpenStruct.new
        message.user = OpenStruct.new
        message.user.nick = username
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ['BattleTag removed']

        @db.expect :execute, nil, ['DELETE FROM Battletags WHERE nick=?', [username]]

        @SUT.removebt(message)

        message.verify
        @db.verify
      end

      def test_a_battletag_should_have_the_right_format
        message = OpenStruct.new
        message.channel = MiniTest::Mock.new
        message.channel.expect :send, nil, ['Bad BattleTag format, example: !addbt Username#1234 EU']

        @SUT.addbt(message, 'foo#12', 'EU')
      end
    end
  end
end
