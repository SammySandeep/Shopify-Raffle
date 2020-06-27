class Customer < ApplicationRecord

  belongs_to :shop
  has_many :participants
  has_many :raffles, through: :participants
  has_one :address

  validates :shopify_customer_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :first_name, presence: true
  validates :first_name, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true
  validates :last_name, format: { with: /[a-zA-Z]/ }
  validates :email_id, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, length: {maximum: 50}, presence: true
  validates :shop_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true

end
