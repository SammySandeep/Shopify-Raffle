class AppProxy::RegistersController < ApplicationController
  before_action :registers_customer_params, only: %i[register_customer]
  def register_customer
    customer = find_customer_by_email
    raffle = find_variant_by_shopify_variant_id.raffle
    if raffle.delivery_method == 'online'
      create_address_for_online(customer.id, raffle.id)
    else  
      create_address(customer.id, raffle.id)
    end
    body = Setting.first.email_body_for_registration
    product = raffle.variant.product
    product_title = product.shopify_product_title
    Mailer::Email.send_registration_confirmation_mail customer, product_title, body
    head 200
  rescue StandardError
    head 400
  end

  private

  def create_address(customer_id, raffle_id)
    address = Address.new(address_params)
    address.customer_id = customer_id
    address.raffle_id = raffle_id
    address.save(validate: false)
  end

  def create_address_for_online(customer_id, raffle_id)
    address = Address.new(address_params)
    address.customer_id = customer_id
    address.raffle_id = raffle_id
    address.save
  end
  
  def find_customer_by_email
    Customer.find_by(email_id: params[:customer_email])
  end

  def find_variant_by_shopify_variant_id
    variants = Variant.where(shopify_variant_id: registers_customer_params[:variant_id])
    variants.each do |variant|
      return variant if variant.product.status == 'pending'
    end
  end

  def registers_customer_params
    params.permit(:address, :city, :country, :state, :customer_email, :phone, :variant_id, :pin)
  end
  
  def address_params
    params.permit(:address, :city, :country, :state, :phone, :pin)
  end
end