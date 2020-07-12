
class AppProxy::RegistersController < ApplicationController
  before_action :registers_customer_params, only: %i[register_customer]
  def register_customer
    customer = find_customer_by_email 
    raffle = find_variant_by_shopify_variant_id.raffle
    create_address(customer.id, raffle.id)
    head 200
  rescue StandardError
    head 400
  end

  private

  def create_address(customer_id, raffle_id)
    address = Address.new(address_params)
    address.customer_id = customer_id
    address.raffle_id = raffle_id
    address.save
  end

  def find_customer_by_email
    Customer.find_by(email_id: params[:customer_email])
  end

  def find_variant_by_shopify_variant_id
    Variant.find_by(shopify_variant_id: registers_customer_params[:variant_id])
  end

  def registers_customer_params
    params.permit(:address, :city, :country, :state, :customer_email, :phone, :variant_id, :pin)
  end

  def address_params
    params.permit(:address, :city, :country, :state, :phone, :pin)
  end
end
