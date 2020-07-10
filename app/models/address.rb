# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :customer

  validates :address, presence: true
  validates :address, format: { with: /[a-zA-Z]/ }
  validates :city, presence: true
  validates :city, format: { with: /[a-zA-Z]/ }
  validates :country, presence: true
  validates :country, format: { with: /[a-zA-Z]/ }
  validates :state, presence: true
  validates :state, format: { with: /[a-zA-Z]/ }
  validates :pin, numericality: { greater_than: 0 }, presence: true
  validates :customer_id, numericality: { greater_than: 0 }, presence: true
end
