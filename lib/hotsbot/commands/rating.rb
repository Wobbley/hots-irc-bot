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
        else
          tr_elements_with_mmr = get_tr_elements_with_mmr(page, username)

          if tr_elements_with_mmr.empty?
            m.target.send 'No rating found for this username'
          else
            send_the_five_firsts_mmr(m, tr_elements_with_mmr)
            m.user.send "Here's the full list of #{username} ratings: #{Rating::URL}#{username}" if tr_elements_with_mmr.count > 5
          end
        end
      end

      def send_the_five_firsts_mmr(m, tr_elements_with_mmr)
        5.times do |i|
          break if tr_elements_with_mmr[i].nil?

          td_elements = tr_elements_with_mmr[i].css('td')
          battletag, rating, region = extract_data_from_td(td_elements)

          m.target.send "[#{region}] #{battletag} — #{rating}"
        end
      end

      def extract_data_from_td(td_elements)
        region = td_elements[1].text
        battletag = td_elements[2].text
        rating = td_elements[4].text
        return battletag, rating, region
      end

      def get_tr_elements_with_mmr(page, username)
        if page.nil?
          page = Nokogiri::HTML(open(URL + username))
        end

        page.css('tbody tr').to_a.select do |tr|
          not tr.nil? and not tr.css('td')[4].nil? and %r{\d+}.match(tr.css('td')[4].text)
        end
      end
    end
  end
end
