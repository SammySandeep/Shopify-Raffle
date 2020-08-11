# frozen_string_literal: true

class Result < ApplicationRecord
  before_save :reduce_customer_chance_by_one

  belongs_to :customer
  belongs_to :raffle
  has_one :notification

  private

  def reduce_customer_chance_by_one
    customer = Customer.find(self.customer_id)
    customer.default_participant_chance -= 1
    customer.save
  end
end
