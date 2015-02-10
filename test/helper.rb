require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rubygems'
require 'minitest/autorun'

module Hotsbot
  class TestCase < Minitest::Test
  end
end
