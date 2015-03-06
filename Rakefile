require 'rubygems'
require 'rake/testtask'
require 'active_record'
require 'yaml'

require File.dirname(__FILE__) + '/lib/utils/configuration'
require File.dirname(__FILE__) + '/lib/hotsbot/bot_factory'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

desc 'Run hotsbot'
task :run do
  Hotsbot::Utils::Configuration.load(File.dirname(__FILE__) + '/config.yml')

  bot = Hotsbot::BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)

  p_read, p_write = IO.pipe

  Thread.start(bot, p_read) do |b, pr|
    pr.read
    pr.close
    b.quit 'Quiting but probably just updating myself brb'
    exit
  end

  ['INT', 'SIGTERM'].each { |signal| trap(signal) { p_write.close } }

  bot.start
end

module Rails
  def self.root
    File.dirname(__FILE__)
  end

  def self.env
    ENV['APP_ENV'] || 'development'
  end
end

include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['APP_ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(config_dir, 'database.yml')))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'
