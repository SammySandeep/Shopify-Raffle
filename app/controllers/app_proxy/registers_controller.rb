
class AppProxy::RegistersController < ApplicationController
  before_action :registers_customer_params, only: %i[register_customer]
  def register_customer
    customer = find_customer_by_email
    raffle = find_variant_by_shopify_variant_id.raffle
    create_address(customer.id, raffle.id)
    reduce_customer_chance_by_one(customer.id)
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

  def reduce_customer_chance_by_one(customer_id)
    customer = Customer.find(customer_id)
    customer.default_participant_chance -= 1
    customer.save
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
