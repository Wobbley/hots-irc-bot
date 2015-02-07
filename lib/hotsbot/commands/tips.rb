require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot::Commands
  class Tips
    include Cinch::Plugin
    include Cinch::Commands

    command :tips, {}, summary: 'Links the tips section'
    command :tips, { username: :string }, summary: 'Links the tips section and highlights user'

    URL = 'http://heroesofthestorm.github.io/tips'

    def tips(m, username=nil)
      if username.nil?
        message = "Tips can be found here: #{URL}"
      else
        message = "You can find some great tips here, #{username}: #{URL}"
      end

      m.channel.send message
    end
  end
end
