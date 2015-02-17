module Hotsbot
  module Commands
    module DbCommand
      def init_db(db=nil, init_query)
        if db.nil?
          @db = SQLite3::Database.new File.dirname(__FILE__) + '/../../../hotsbot.db'
        else
          @db = db
        end

        @db.execute init_query
      end

      def db
        @db
      end
    end
  end
end
