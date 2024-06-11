# frozen_string_literal: true

module Utils
  def generate_key(length)
    ('a1A'..'z9Z').to_a.sample(length / 3).join
  end
end
