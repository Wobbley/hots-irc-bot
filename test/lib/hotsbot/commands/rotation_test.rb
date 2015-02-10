require 'ostruct'
require 'minitest/mock'

require File.dirname(__FILE__) + '/../../../helper'
require File.dirname(__FILE__) + '/../../../../lib/hotsbot/commands/rotation'

module Hotsbot
  module Commands
    class RotationTest < Hotsbot::TestCase
      def test_can_parse_rotation_list
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        heroes_list = []
        heroes_names = ['Diablo', 'Muradin', 'Raynor', 'Rehgar', 'Tyrande', 'Azmodan', 'Zeratul']
        heroes_names.each do |h|
          hero = OpenStruct.new
          hero.text = h
          heroes_list.push hero
        end

        page = MiniTest::Mock.new
        page.expect :nil?, false
        page.expect :css, heroes_list, ['button.btn:not(.dropdown-toggle)']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["Free rotation list: #{heroes_names.join(', ')}"]

        Rotation.new(bot, page).rotation(message)

        page.verify
        message.target.verify
      end

      def test_if_list_is_empty_print_url
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        page = MiniTest::Mock.new
        page.expect :nil?, false
        page.expect :css, [], ['button.btn:not(.dropdown-toggle)']

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ["Free rotation list: #{Rotation::URL}"]

        Rotation.new(bot, page).rotation(message)

        page.verify
        message.target.verify
      end

      def test_if_2_lists_are_available_display_the_right_one
        bot = Cinch::Bot.new
        bot.loggers.level = :fatal

        page = Nokogiri::HTML(open(File.dirname(__FILE__) +'/../../../fixtures/rotation.html'))

        message = OpenStruct.new
        message.target = MiniTest::Mock.new
        message.target.expect :send, nil, ['Free rotation list: Jaina, Malfurion, Tassadar, Tyrael, Valla, Zagara, Chen']

        Rotation.new(bot, page).rotation(message)

        message.target.verify
      end
    end
  end
end
