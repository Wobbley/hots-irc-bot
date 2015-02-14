module Hotsbot
  module Commands
    module UrlPrinter
      def self.included(klass)
        klass.class_eval "command :#{klass::COMMAND}, {}, summary: \"#{klass::COMMAND_SUMMARY}\", description: \"#{klass::COMMAND_SUMMARY}\""
        define_method klass::COMMAND do |m|
          m.target.send klass::COMMAND_MESSAGE
        end
      end

    end
  end
end
