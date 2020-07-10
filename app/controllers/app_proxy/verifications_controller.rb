class AppProxy::VerificationsController < ApplicationController
  include ShopifyApp::AppProxyVerification
  before_action :verification_params_for_send_otp, only: %i[send_otp]
  before_action :verification_params_for_verify_otp, only: %i[verify_otp]

  def send_otp
    # validate user registered for this product
    customer = find_customer_by_email_id
    if validate_if_customer_already_registered customer
      head 406
      return
    end
    if customer.default_participant_chance < 0
      head 403
      return
    end
    if !customer.verified
      random_six_digit_number = SecureRandom.random_number(999999).to_s
      customer_verification = customer.verification
      if customer_verification.nil?
        Verification.create(
          code: random_six_digit_number,
          customer_id: customer.id
        )
      else
        customer_verification.code = random_six_digit_number
        customer_verification.save
      end
      binding.pry
      head 200
    else
      head 202
    end
    # head 403 no chance left message
  end

  def verify_otp
    customer = Customer.find_by(email_id: verification_params_for_verify_otp[:email_id])
    crypt = ActiveSupport::MessageEncryptor.new(ENV['KEY'])
    decrypted_data = crypt.decrypt_and_verify(customer.verification.code)
    if decrypted_data == verification_params_for_verify_otp[:code]
      customer_expiration_date_time = find_customer_verification_code_expiration_date_time customer
      if customer_expiration_date_time.localtime >= DateTime.now
        customer.verified = true
        customer.save
        head 200
        return
      end
      head 406
    else
      head 401
    end
  end

  private

  def validate_if_customer_already_registered customer
    customer.raffles.each do |raffle|
      product = raffle.variant.product
      if product.shopify_product_id == verification_params_for_send_otp[:shopify_product_id].to_i && product.status != 'completed'
        return true
      end
    end
    return false
  end

  def find_customer_verification_code_expiration_date_time customer
    customer_verification_code_updated_at = customer.verification.updated_at
    customer_verification_code_updated_at_min = customer_verification_code_updated_at.min
    customer_verification_code_expire_at_min = customer_verification_code_updated_at_min + ENV['OTP_DURATION'].to_i
    if customer_verification_code_expire_at_min >= 60
      return customer_verification_code_updated_at.change(hour: customer_verification_code_updated_at.hour + 1, min: customer_verification_code_expire_at_min - 60)
    end
    return customer_verification_code_updated_at.change(min: customer_verification_code_expire_at_min)
  end

  def find_customer_by_email_id
    Customer.find_by(email_id: verification_params_for_send_otp[:email])
  end

  def validate_email
    verification_params_for_send_otp[:email].match(/^.+@+[a-zA-Z].+$/) ? true : false
  end

  def verification_params_for_send_otp
    params.permit(:email, :shopify_product_id)
  end

  def verification_params_for_verify_otp
    params.permit(:code, :email_id)
  end
end