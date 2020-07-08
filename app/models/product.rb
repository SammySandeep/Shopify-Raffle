# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :shop
  has_many :variants, dependent: :destroy

  validates :shopify_product_title, presence: true
  validates :shopify_product_id, numericality: { greater_than: 0 }, presence: true
  validates :has_variant, inclusion: { in: [true, false] }
  validates :shop_id, numericality: { greater_than: 0 }, presence: true
end
