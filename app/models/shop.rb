# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage
  include ApplicationHelper
  after_save :get_customers

  has_one :setting
  has_many :products
  has_many :raffles

  def api_version
    ShopifyApp.configuration.api_version
  end

  private
  
  def get_customers 
    Sync::Customers.perform_now
  end

end 
