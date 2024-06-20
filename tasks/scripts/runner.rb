# frozen_string_literal: true

require_relative '../../config/config'
require 'sequel'

# This module has methods for fetching data from the source database and inserting it into the target database.
# rubocop:disable Metrics/ModuleLength
module Runner
  # This method fetches data from the source database and inserts it into the target database.
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def fetch
    source = Sequel.connect(adapter: :tinytds,
                            host: 'source.company.local',
                            database: 'sales_database',
                            port: 1433,
                            timeout: 500)
    target = Sequel.connect(adapter: :tinytds,
                            host: 'target.company.local',
                            database: 'reports_database',
                            port: TARGET_PORT,
                            timeout: 500)

    puts "Running in development mode on port: #{TARGET_PORT}" unless TARGET_PORT == 1433

    sql = "SELECT
                store_id,
                store_name,
                sales_order_id,
                sales_order_number,
                sales_order_payment_value
           FROM SalesOrders
           WHERE sales_order_insert >= DATEADD(MINUTE, -5, GETDATE())
           "

    result = source.fetch(sql).all

    table = Sequel.qualify('staging', 'SalesOrders')

    target.run('DELETE FROM staging.SalesOrders')

    target.transaction do
      result.each_slice(1000) do |chunk|
        target[table].multi_insert(chunk)
      end
    end

    puts 'Successfully fetched data to staging...'
    $stdout.flush

    target.run("
      MERGE INTO reports.SalesOrders AS target
      USING staging.SalesOrders AS source
      ON target.sales_order_id = source.sales_order_id
      WHEN NOT MATCHED THEN
        INSERT (store_id, store_name, sales_order_id, sales_order_number, sales_order_payment_value)
        VALUES (source.store_id, source.store_name, source.sales_order_id,
                source.sales_order_number, source.sales_order_payment_value);
      ")

    puts 'Successfully inserted data to target table...'
  rescue Sequel::DatabaseError => e
    puts "Database error: #{e.message}"
    $stdout.flush
  ensure
    source.disconnect
    target.disconnect
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ModuleLength
