require 'rubygems'
require 'cinch'
require 'cinch/commands'

module Hotsbot
  module Commands
    class Help < Cinch::Commands::Help
      include Cinch::Commands

      command :help, {command: :string},
              summary:     %{Displays help information for the COMMAND},
              description: %{
                Finds the COMMAND and prints the usage and description for the
                COMMAND.
              }

      command :help, {},
              summary: "Lists available commands",
              description: %{
                If no COMMAND argument is given, then all commands will be listed.
              }

      # override the method to send help to the user only
      def help(m,command=nil)
        if command
          found = commands_named(command)

          if found.empty?
            m.user.send "help: Unknown command #{command.dump}"
          else
            found.each { |cmd| m.reply cmd.usage }

            m.user.send ''
            m.user.send found.first.description
          end
        else
          each_command do |cmd|
            m.user.send "#{cmd.usage} - #{cmd.summary}"
          end
        end
      end
    end
  end
end
