# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage
  after_save :sync_data

  has_one :setting
  has_many :products
  has_many :raffles

  def api_version
    ShopifyApp.configuration.api_version
  end

  private
  
 def sync_data
  session_create
  sync_customer
 end

 def session_create
  session = ShopifyAPI::Session.new(domain: shopify_domain, token: shopify_token, api_version: api_version)
  ShopifyAPI::Base.activate_session(session)
end

def sync_customer
  begin
   customers = ShopifyAPI::Customer.find(:all, params: {limit: 250})
   customers_array = []
   loop do
     customers_array += customers
     break unless customers.next_page?
   
     customers = customers.fetch_next_page
  end
 rescue StandardError
  retry
 end  
  customers_array.each do |customer|
    if customer.addresses.present?
      @customer = Customer.create(
      shopify_customer_id: customer.id,
      first_name: customer.first_name,
      last_name: customer.last_name,
      email_id: customer.email,
      shop_id: id
    )
      customer.addresses.each do |address|  
      Address.create(
       line1: address.address1,
       line2: address.address2,
       city: address.city,
       country: address.country,
       state: address.province,
       pin: address.zip,
       customer_id: @customer.id
     )
   end
  end
 end 
end
end 