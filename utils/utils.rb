# frozen_string_literal: true

# This module provides utility methods for the api.
module Utils
  def self.generate_key
    length = rand(64..72).to_i

    ('a1A'..'z9Z').to_a.sample(length / 3).join
  end
end
