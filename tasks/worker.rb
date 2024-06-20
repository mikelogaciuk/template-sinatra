# frozen_string_literal: true

require 'rufus-scheduler'
require_relative './scripts/runner'

scheduler = Rufus::Scheduler.new

scheduler.every '1m', first_in: '10s' do
  include Runner

  puts 'Getting Sales Orders from Source..'

  fetch

  $stdout.flush
rescue Exception => e
  puts "Exception occurred: #{e.message}"
  $stdout.flush
end

scheduler.join
