
class AppProxy::RegistersController < ApplicationController
  # before_action :registers_customer_params, only: %i[register_customer]
  def register_customer
    begin
      address = Address.new(address_params)
      customer = find_customer_by_email
      address.customer_id = customer.id
      raffle = find_variant_by_shopify_variant_id.raffle
      address.raffle_id = raffle.id
      address.save
      create_result(raffle, customer)
      head 200
    rescue StandardError
      head 400
    end
  end

  private

  def create_result(raffle, customer)
    Result.create(
      raffle_id: raffle.id,
      customer_id: customer.id,
      type_of_customer: 'participant'
    )
  end

  def find_customer_by_email
    Customer.find_by(email_id: params[:customer_email])
  end

  def find_variant_by_shopify_variant_id
    Variant.find_by(shopify_variant_id: registers_customer_params[:variant_id])
  end

  def registers_customer_params
    params.permit(:address, :city, :country, :state, :customer_email, :phone, :variant_id)
  end

  def address_params
    params.permit(:address, :city, :country, :state, :phone, :pin)
  end
end
