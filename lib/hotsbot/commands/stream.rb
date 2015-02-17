require 'rubygems'
require 'cinch'
require 'cinch/commands'
require 'sqlite3'
require 'kappa'

require File.dirname(__FILE__) + '/db_command'

module Hotsbot
  module Commands
    class Stream
      include Cinch::Plugin
      include Cinch::Commands
      include DbCommand

      command :streams, {},
              summary: 'List live featured streams',
              description: 'List live featured streams'

      match Command.new('addstream', {stream: :string}).regexp, method: :add_stream
      match Command.new('removestream', {stream: :string}).regexp, method: :remove_stream
      match Command.new('liststreams', {}).regexp, method: :list_streams

      def initialize(bot, db=nil)
        super bot

        init_db db, 'CREATE TABLE IF NOT EXISTS Streams (channel_name text)'
      end

      def streams(m)
        results = db.execute 'SELECT channel_name FROM Streams'

        return m.target.send 'No streams yet!' if results.empty?

        m.target.send "[Online streamers] #{get_streams_url_and_views(results).join(' — ')}"
      end

      def get_streams_url_and_views(results)
        streams = []

        results.each do |s|
          channel = Twitch.channels.get(s.first)
          streams << "#{channel.url} (#{channel.stream.viewer_count})" if channel.streaming?
        end
        streams
      end

      def add_stream(m, stream)
        return m.user.send 'You are not allowed to add streams' unless is_user_admin(m)

        channel_name = get_channel_name(stream)

        db.execute 'INSERT INTO Streams VALUES (?)', [channel_name]
        m.user.send 'Stream added'
      end

      def remove_stream(m, stream)
        return m.user.send 'You are not allowed to remove streams' unless is_user_admin(m)

        db.execute 'DELETE FROM Streams WHERE channel_name=?', [get_channel_name(stream)]
        m.user.send 'Stream removed'
      end

      def list_streams(m)
        if is_user_admin(m)
          channel_names = db.execute('SELECT channel_name FROM Streams').map { |c| c.first }
          m.user.send channel_names.join(' — ')
        end
      end

      def get_channel_name(stream)
        stream[%r{(?:http://www.twitch.tv/)?(.*)},1]
      end

      def is_user_admin(m)
        config[:admins].include?(m.user.nick)
      end
    end
  end
end
