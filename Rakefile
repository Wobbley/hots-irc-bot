require 'rubygems'
require 'rake/testtask'
require 'app_conf'

require File.dirname(__FILE__) + '/lib/hotsbot/bot_factory'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

Rake::Task

desc 'Run hotsbot'
task :run do
  configuration = AppConf.new
  configuration.load(File.dirname(__FILE__) + '/config.yml')

  bot = BotFactory.from_configuration(configuration)
  bot.start
end
