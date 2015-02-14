require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/stream'

module Hotsbot
  module Commands
    class StreamTest < TestCase
      def setup
        @admins = ['foo_admin']

        bot = Cinch::Bot.new
        bot.loggers.level = :fatal
        bot.config.plugins.options[Stream] = { admins: @admins}

        @db = MiniTest::Mock.new
        @db.expect :nil?, false
        @db.expect :execute, nil, [String]

        @SUT = Stream.new(bot, @db)
      end

      def test_create_database_if_not_exists
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        db = MiniTest::Mock.new
        db.expect :nil?, false
        db.expect :execute, nil, ['CREATE TABLE IF NOT EXISTS Streams (channel_name text)']

        Stream.new(bot, db)

        db.verify
      end

      def test_can_list_online_stream
        stream = 'foochannel'
        stream_url = "http://www.twitch.tv/#{stream}"
        stream_viewers = '60'
        stream_2 = 'barchannel'
        stream_2_url = "http://www.twitch.tv/#{stream_2}"
        stream_2_viewers = '120'

        @db.expect :execute, [[stream], [stream_2]], ['SELECT channel_name FROM Streams']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["[Online streamers] #{stream_url} (#{stream_viewers}) — #{stream_2_url} (#{stream_2_viewers})"]

        stream = MiniTest::Mock.new
        stream.expect :viewer_count, stream_viewers
        stream.expect :viewer_count, stream_2_viewers

        channel = MiniTest::Mock.new
        channel.expect :streaming?, true
        channel.expect :streaming?, true
        channel.expect :url, stream_url
        channel.expect :url, stream_2_url
        channel.expect :stream, stream
        channel.expect :stream, stream

        Twitch.channels.stub :get, channel do
          @SUT.streams(message)
        end

        @db.verify
        message.target.verify
        channel.verify
      end

      def test_if_no_stream_say_so
        @db.expect :execute, [], ['SELECT channel_name FROM Streams']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ['No streams yet!']

        @SUT.streams(message)

        @db.verify
        message.target.verify
      end

      def test_can_add_stream
        channel_name = 'FooChannel'
        stream = "http://www.twitch.tv/#{channel_name}"

        @db.expect :execute, [], ['INSERT INTO Streams VALUES (?)', [channel_name]]

        message = OpenStruct.new
        get_message_from_user(message)
        message.user.expect :send, nil, ['Stream added']

        @SUT.add_stream(message, stream)

        @db.verify
        message.user.verify
      end

      def test_can_add_stream_via_channel_name_only
        stream = 'FooChannel'

        @db.expect :execute, [], ['INSERT INTO Streams VALUES (?)', [stream]]

        message = OpenStruct.new
        get_message_from_user(message)
        message.user.expect :send, nil, ['Stream added']

        @SUT.add_stream(message, stream)

        @db.verify
        message.user.verify
      end

      def test_only_admin_can_add_stream
        message = OpenStruct.new
        get_message_from_user(message, 'not_admin')
        message.user.expect :send, nil, ['You are not allowed to add streams']

        @SUT.add_stream(message, 'FooChannel')

        @db.verify
        message.user.verify
      end

      def test_can_remove_stream_from_channel_name
        channel_name = 'FooChannel'

        @db.expect :execute, [], ['DELETE FROM Streams WHERE channel_name=?', [channel_name]]

        message = OpenStruct.new
        get_message_from_user(message)
        message.user.expect :send, nil, ['Stream removed']

        @SUT.remove_stream(message, channel_name)

        @db.verify
        message.user.verify
      end

      def test_can_remove_stream
        channel_name = 'FooChannel'

        @db.expect :execute, [], ['DELETE FROM Streams WHERE channel_name=?', [channel_name]]

        message = OpenStruct.new
        get_message_from_user(message)
        message.user.expect :send, nil, ['Stream removed']

        @SUT.remove_stream(message, "http://www.twitch.tv/#{channel_name}")

        @db.verify
        message.user.verify
      end

      def test_only_admin_can_remove_stream
        message = OpenStruct.new
        get_message_from_user(message, 'not_admin')
        message.user.expect :send, nil, ['You are not allowed to remove streams']

        @SUT.remove_stream(message, 'FooChannel')

        @db.verify
        message.user.verify
      end

      def test_can_list_streams
        channel_names = [['foo'], ['bar'], ['baz']]

        @db.expect :execute, channel_names, ['SELECT channel_name FROM Streams']

        message = OpenStruct.new
        get_message_from_user(message)
        message.user.expect :send, nil, [channel_names.join(' — ')]

        @SUT.list_streams(message)

        @db.verify
        message.user.verify
      end

      def test_list_streams_do_nothing_if_not_admin
        message = OpenStruct.new
        get_message_from_user(message, 'not_admin')

        @SUT.list_streams(message)

        @db.verify
        message.user.verify
      end

      def get_message_from_user(message, user=@admins.first)
        message.user = MiniTest::Mock.new
        message.user.expect :nick, user
      end
    end
  end
end
