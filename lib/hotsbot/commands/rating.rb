require 'rubygems'
require 'cinch'
require 'cinch/commands'
require 'nokogiri'
require 'open-uri'

module Hotsbot
  module Commands
    class Rating
      include Cinch::Plugin
      include Cinch::Commands

      URL = 'https://www.hotslogs.com/PlayerSearch?NoRedirect=1&Name='

      match 'rating', method: :rating
      command :rating, { username: :string }, summary: 'Replies with a list of players with the given BattleTag from HotsLogs'

      def rating(m, username=nil, page=nil)
        if username.nil?
          m.target.send 'Get Hotslogs rating from BattleTag, example: !rating username'
          return
        end

        if page.nil?
          page = Nokogiri::HTML(open(URL + username))
        end

        tr_elements = page.css('tbody tr')

        if tr_elements.empty?
          m.target.send 'No rating found for this username'
          return
        end

        5.times do |i|
          break if tr_elements[i].nil?

          td_elements = tr_elements[i].css('td')
          region = td_elements[1].text
          battletag = td_elements[2].text
          rating = td_elements[4].text

          m.target.send "[#{region}] #{battletag} — #{rating}" if %r{\d+}.match(rating)
        end

        m.target.send "Here's the full list of #{username} ratings: #{Rating::URL}#{username}" if tr_elements.count > 5
      end
    end
  end
end
