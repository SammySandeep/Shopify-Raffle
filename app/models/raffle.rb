# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :shop
  has_many :participants
  has_many :customers, through: :participants

  # validates :title, format: { with: /\A[a-zA-Z0-9]\-\z/ }
  validates :raffle_date, presence: true
  validates :shop_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :winner_customer_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :delivery_method, inclusion: { in: %w[online offline] }
  validates :result, presence: true
  validates :shopify_product_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :inventry, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  
end
