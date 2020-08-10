# frozen_string_literal: true

class Result < ApplicationRecord
  before_save :reduce_customer_chance_by_one

  belongs_to :customer
  belongs_to :raffle
  has_one :notification

end
