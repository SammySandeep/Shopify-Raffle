# frozen_string_literal: true

class Variant < ApplicationRecord
  has_many :raffles
  belongs_to :product
end
