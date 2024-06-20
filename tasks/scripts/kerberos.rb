# frozen_string_literal: true

require_relative '../../config/config'

# Module responsible for refreshing Kerberos ticket
module Kerberos
  def refresh
    puts 'Refreshing Kerberos Ticket...'

    system("echo #{DOMAIN_PASSWORD} | kinit #{DOMAIN_USER}@COMPANY.LOCAL")

    puts 'Kerberos Ticket Refreshed.'
  end
end
