# frozen_string_literal: true

class Variant < ApplicationRecord
  has_one :raffle
  belongs_to :product
end
