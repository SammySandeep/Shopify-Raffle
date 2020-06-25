# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :shop

  validates :shopify_product_title, presence: true
  validates :shopify_product_title, format: { with: /[a-zA-Z]/ }
  validates :shopify_product_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :has_variant, presence: true
  validates :has_variant, inclusion: { in: [true, false] }
  validates :shop_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
end
