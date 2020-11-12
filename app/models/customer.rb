# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :shop

  has_one :verification
  has_many :results
  has_many :raffles, through: :results
  has_one :address

  validates :shopify_customer_id, numericality: { greater_than: 0 }, presence: true, uniqueness: { scope: :shop_id }
  validates :shop_id, numericality: { greater_than: 0 }, presence: true
  
end
