# frozen_string_literal: true

class Variant < ApplicationRecord
  has_one :raffle, dependent: :destroy
  belongs_to :product
end
