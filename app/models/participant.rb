# frozen_string_literal: true

class Participant < ApplicationRecord

  belongs_to :raffle
  belongs_to :customer

  after_create :update_chance

  validates :raffle_id, numericality: { greater_than: 0 }, presence: true
  validates :customer_id, numericality: { greater_than: 0 }, presence: true

  private

  def update_chance
    @customer = Customer.find(customer_id)
    @customer.default_participant_chance -= 1
    @customer.save
  end
end
