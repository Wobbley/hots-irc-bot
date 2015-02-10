require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/rating'

module Hotsbot
  module Commands
    class RatingTest < Hotsbot::TestCase
      def test_can_get_rating
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        region = 'EU'
        username = 'Username'
        rating = '2500'
        td_elements = []
        ['', region, username, '', rating].each do |d|
          td_element = OpenStruct.new
          td_element.text = d
          td_elements.push td_element
        end

        tr_element = MiniTest::Mock.new
        tr_element.expect :nil?, false
        tr_element.expect :nil?, false
        tr_element.expect :nil?, true
        tr_element.expect :css, td_elements, ['td']
        tr_element.expect :css, td_elements, ['td']
        tr_element.expect :css, td_elements, ['td']
        tr_elements = [tr_element]

        page = MiniTest::Mock.new
        page.expect :nil?, false
        page.expect :css, tr_elements, ['tbody tr']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["[#{region}] #{username} — #{rating}"]

        Rating.new(bot).rating(message, username, page)

        page.verify
        message.target.verify
      end

      def test_if_list_is_empty_say_so
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        page = MiniTest::Mock.new
        page.expect :nil?, false
        page.expect :css, [], ['tbody tr']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ['No rating found for this username']

        Rating.new(bot).rating(message, 'username', page)

        page.verify
        message.target.verify
      end

      def test_if_no_username_is_given_display_help
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ['Get Hotslogs rating from BattleTag, example: !rating username']

        Rating.new(bot).rating(message)

        message.target.verify
      end

      def test_can_if_more_than_5_ratings_print_5_and_link_to_full_list
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        region = 'EU'
        username = 'Username'
        rating = '2500'
        td_elements = []
        ['', region, username, '', rating].each do |d|
          td_element = OpenStruct.new
          td_element.text = d
          td_elements.push td_element
        end

        tr_elements = []
        6.times do |i|
          tr_element = MiniTest::Mock.new
          tr_element.expect :nil?, false
          tr_element.expect :css, td_elements, ['td']
          tr_element.expect :css, td_elements, ['td']

          if i < 5
            tr_element.expect :nil?, false
            tr_element.expect :css, td_elements, ['td']
          end

          tr_elements.push tr_element
        end

        page = MiniTest::Mock.new
        page.expect :nil?, false
        page.expect :css, tr_elements, ['tbody tr']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        5.times { message.target.expect :send, nil, ["[#{region}] #{username} — #{rating}"] }
        message.user = MiniTest::Mock.new
        message.user.expect :send, nil, ["Here's the full list of #{username} ratings: #{Rating::URL}#{username}"]

        Rating.new(bot).rating(message, username, page)

        page.verify
        message.target.verify
      end

      def test_do_not_display_empty_rating
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        page = Nokogiri::HTML(open(File.dirname(__FILE__) +'/../../../fixtures/search_with_empty_mmr.html'))

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ['[EU] Kenzi — 2175']

        Rating.new(bot).rating(message, 'Kenzi', page)

        message.target.verify
      end
    end
  end
end
