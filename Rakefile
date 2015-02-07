require 'rubygems'
require 'rake/testtask'

require File.dirname(__FILE__) + '/lib/utils/configuration'
require File.dirname(__FILE__) + '/lib/hotsbot/bot_factory'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

Rake::Task

desc 'Run hotsbot'
task :run do
  Hotsbot::Utils::Configuration.load(File.dirname(__FILE__) + '/config.yml')

  bot = Hotsbot::BotFactory.from_configuration(Hotsbot::Utils::Configuration.config)
  bot.start
end
