# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage
  after_save :get_customers

  has_one :setting
  has_many :products
  has_many :customers
  has_many :raffles

  def api_version
    ShopifyApp.configuration.api_version
  end

  private
  
  def get_customers 
    Sync::Customers.perform_async(self.id)
  end

end 
