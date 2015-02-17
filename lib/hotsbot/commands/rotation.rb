require 'rubygems'
require 'cinch'
require 'cinch/commands'
require 'nokogiri'
require 'open-uri'

module Hotsbot
  module Commands
    class Rotation
      include Cinch::Plugin
      include Cinch::Commands

      URL = 'http://heroesofthestorm.github.io/free-hero-rotation'

      command :rotation, {},
              summary: 'Prints the current free hero rotation',
              description: 'Prints the current free hero rotation'

      def rotation(m, page=nil)
        page = init_page(page)

        heroes_list = page.css('button.btn:not(.dropdown-toggle)').to_a[0..6].map { |e| e.text }

        if heroes_list.empty?
          m.target.send "Free rotation list: #{URL}"
        else
          m.target.send "Free rotation list: #{heroes_list.join(', ')}"
        end
      end

      def init_page(page)
        if page.nil?
          page = Nokogiri::HTML(open(URL))
        end

        page
      end
    end
  end
end
