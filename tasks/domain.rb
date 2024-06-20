# frozen_string_literal: true

require 'rufus-scheduler'
require_relative './scripts/kerberos'

scheduler = Rufus::Scheduler.new

scheduler.every '1h', first_in: '5s' do
  include Kerberos

  refresh

  $stdout.flush
rescue Exception => e
  puts "Exception occurred: #{e.message}"
  $stdout.flush
end

scheduler.join
