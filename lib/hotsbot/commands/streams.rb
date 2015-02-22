require 'rubygems'
require 'cinch'
require 'cinch/commands'
require 'sqlite3'
require 'kappa'

require File.dirname(__FILE__) + '/db_command'

module Hotsbot
  module Commands
    class Streams
      include Cinch::Plugin
      include Cinch::Commands
      include DbCommand

      command :streams, {},
              summary: 'List live featured streams',
              description: 'List live featured streams'

      match Command.new('addstream', {stream: :string}).regexp, method: :add_stream
      match Command.new('removestream', {stream: :string}).regexp, method: :remove_stream
      match Command.new('liststreams', {}).regexp, method: :list_streams

      timer 10*60, method: :refresh_streams
      match 'refreshstreams', method: :refresh_streams

      def initialize(bot, db=nil)
        super bot

        init_db db, 'CREATE TABLE IF NOT EXISTS Streams (channel_name text, channel_url text null, viewer_count int null, live tinyint null)'
      end

      def streams(m)
        results = db.execute 'SELECT channel_url, viewer_count FROM Streams WHERE live = 1'

        return m.target.send 'No streams currently online!' if results.empty?

        m.target.send "[Online streamers] #{get_streams_url_and_views(results).join(' — ')}"
      end

      def get_streams_url_and_views(results)
        streams = []

        results.each do |s|
          streams << "#{s[0]} (#{s[1]})"
        end
        streams
      end

      def add_stream(m, stream)
        return m.user.send 'You are not allowed to add streams' unless is_user_admin(m)

        channel_name = get_channel_name(stream)

        db.execute 'INSERT INTO Streams (channel_name) VALUES (?)', [channel_name]
        cache_stream_data channel_name

        m.user.send 'Stream added'
      end

      def remove_stream(m, stream)
        return m.user.send 'You are not allowed to remove streams' unless is_user_admin(m)

        db.execute 'DELETE FROM Streams WHERE channel_name=?', [get_channel_name(stream)]
        m.user.send 'Stream removed'
      end

      def list_streams(m)
        if is_user_admin(m)
          channel_names = get_all_channel_names
          m.user.send channel_names.join(' — ')
        end
      end

      def get_all_channel_names
        db.execute('SELECT channel_name FROM Streams').map { |c| c.first }
      end

      def refresh_streams(m=nil)
        get_all_channel_names.each do |c|
          cache_stream_data c
        end

        m.user.send 'Streams refresh done' unless m.nil?
      end

      def get_channel_name(stream)
        stream[%r{(?:http://www.twitch.tv/)?(.*)},1]
      end

      def is_user_admin(m)
        config[:admins].include?(m.user.nick)
      end

      def cache_stream_data(channel_name)
        channel = Twitch.channels.get(channel_name)
        if channel
          viewer_count = channel.stream.nil? ? 0 : channel.stream.viewer_count
          @db.execute(
            'UPDATE Streams SET channel_url=?, viewer_count=?, live=? WHERE channel_name=?',
            [channel.url, viewer_count, channel.streaming? ? 1 : 0, channel_name]
          )
        end
      end
    end
  end
end
