# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :variant

  has_many :results, dependent: :destroy
  has_many :customers, through: :results

  has_many :addresses, dependent: :destroy

  validates :title, presence: true
  validates :delivery_method, inclusion: { in: ['online', 'offline', nil] }


  def self.raffle_products_and_variants shop
    products = shop.products
    raffles = Array.new
    products.each do |product|
      product.variants.each do |variant|
        raffles.push(variant.raffle) 
      end
    end
    return raffles 
  end

  def self.create_notification_and_reduce_quantity result_id, raffle
    Notification.create(result_id: result_id,notified: true)
    raffle.variant.inventory_quantity -= 1
    raffle.variant.save
  end

  def self.send_email_for_winner_customer raffle, winner_customer, shop
    product = raffle.variant.product
    product_title = product.shopify_product_title
    url = "#{ENV['URL']}/links/expiration?raffle_id=#{raffle.id.to_s}&customer_id=#{winner_customer.id.to_s}"
    body = shop.setting.email_body_for_winner
    Mailer::Email.send_winner_mail product_title, raffle, winner_customer, url, body
  end

  def self.send_mail_for_participants raffle, participant_customers, shop
    product = raffle.variant.product
    product_title = product.shopify_product_title
    body = shop.setting.email_body_for_participant
    participant_customers.each do |customer|
      Mailer::Email.send_participants_mail product_title, raffle, customer, body
    end
  end
end

