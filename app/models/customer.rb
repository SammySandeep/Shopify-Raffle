# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :shop

  has_one :verification
  has_many :results
  has_many :raffles, through: :results
  has_one :address

  validates :shopify_customer_id, numericality: { greater_than: 0 }, presence: true
  validates :default_participant_chance, numericality: { greater_than_or_equal_to: -1 }
  validates :shop_id, numericality: { greater_than: 0 }, presence: true
end
