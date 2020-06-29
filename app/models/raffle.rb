# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :shop

  has_many :participants
  has_many :customers, through: :participants

  validates :title, presence: true
  validates :shop_id, numericality: { greater_than: 0 }, presence: true
  validates :delivery_method, inclusion: { in: ['online', 'offline', nil] }
  validates :shopify_product_id, numericality: { greater_than: 0 }, presence: true
  validates :inventory, numericality: true, presence: true
end
