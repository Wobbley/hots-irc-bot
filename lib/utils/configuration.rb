require 'rubygems'
require 'app_conf'

module Hotsbot
  class Configuration
    @@config = nil

    def self.load(configuration_file)
      @@config = AppConf.new
      @@config.load(configuration_file)
    end

    def self.config
      @@config
    end
  end
end
