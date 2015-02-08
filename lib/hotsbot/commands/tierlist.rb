require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot
  module Commands
    class Tierlist
      include Cinch::Plugin
      include Cinch::Commands

      command :tierlist, {}, summary: 'Replies with the url for the Zuna tierlist'

      URL = 'http://heroesofthestorm.github.io/zuna-tierlist'

      def tierlist(m)
        m.target.send URL
      end
    end
  end
end
