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

    command(
      :addbt,
      { battletag: %r{^[a-zA-Z0-9]+[#]\d{4,5}$}, region: %r{[a-zA-Z]{2}} }
    )

    def initialize(bot, db=nil)
      super bot

      if db.nil?
        @db = SQLite3::Database.new File.dirname(__FILE__) + '/../../../hotsbot.db'
      else
        @db = db
      end

      @db.execute 'CREATE TABLE IF NOT EXISTS Battletags (nick text, battletag text)'
    end

    def getbt(m, username=nil)
      if username.nil?
        m.user.send 'A irc username is required, example: "!getbt Ravilan"'
      else
        result = @db.execute('SELECT battletag FROM Battletags WHERE nick=? COLLATE NOCASE', [username])

        if result.empty?
          m.channel.send "No BattleTag found for #{username}"
        else
          battletag = result.first.first
          m.channel.send "#{username}'s BattleTag is #{battletag}"
        end
      end
    end

    def addbt(m, battletag)
      @db.execute('INSERT INTO Battletags VALUES (?, ?)', [m.user.nick, battletag])

      m.channel.send 'Battletag added'
    end
  end
end
