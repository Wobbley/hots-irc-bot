require 'rubygems'
require 'cinch'
require 'cinch/commands'
require 'sqlite3'

module Hotsbot::Commands
  class Battletags
    include Cinch::Plugin
    include Cinch::Commands

    match 'getbt', method: :getbt
    command(
      :getbt,
      { username: :string },
      summary: 'Print the BattleTag for the entered name'
    )

    match 'addbt', method: :addbt
    command(
      :addbt,
      { battletag: :string, region: :string },
      summary: 'Saves your BattleTag'
    )

    def initialize(bot, db=nil)
      super bot

      if db.nil?
        @db = SQLite3::Database.new File.dirname(__FILE__) + '/../../../hotsbot.db'
      else
        @db = db
      end

      @db.execute 'CREATE TABLE IF NOT EXISTS Battletags (nick text, battletag text, region text)'
    end

    def getbt(m, username=nil)
      if username.nil?
        m.user.send 'A IRC username is required, example: !getbt Username'
      else
        result = load_battletag(username)

        if result.empty?
          m.channel.send "No BattleTag found for #{username}"
        else
          battletag = result.first.first
          region = result.first[1]

          m.channel.send "#{username}'s BattleTag is [#{region}]#{battletag}"
        end
      end
    end

    def load_battletag(username)
      @db.execute('SELECT battletag, region FROM Battletags WHERE nick=? COLLATE NOCASE', [username])
    end

    def addbt(m, battletag=nil, region=nil)
      if battletag.nil? or region.nil?
        m.channel.send 'A battletag and region are required, example: !addbt Username#123 EU'
      else
        result = load_battletag(m.user.nick)
        if result.empty?
          @db.execute('INSERT INTO Battletags VALUES (?, ?, ?)', [m.user.nick, battletag, region])
          m.channel.send 'Battletag added'
        else
          @db.execute('UPDATE Battletags SET battletag = ?, region = ? WHERE nick = ?', [battletag, region, m.user.nick])
          m.channel.send 'Battletag updated'
        end
      end
    end
  end
end
