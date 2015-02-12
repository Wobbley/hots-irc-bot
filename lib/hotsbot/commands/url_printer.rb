module Hotsbot
  module Commands
    module UrlPrinter
      def self.included(klass)
        klass.class_eval "command :#{klass::COMMAND}"
        define_method klass::COMMAND do |m|
          m.target.send klass::COMMAND_MESSAGE
        end
      end

    end
  end
end
