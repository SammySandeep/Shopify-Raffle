
class AppProxy::VerificationsController < ApplicationController
  include ShopifyApp::AppProxyVerification
  before_action :verification_params_for_send_otp, only: %i[send_otp]
  before_action :verification_params_for_verify_otp, only: %i[verify_otp]

  # status of 200 valid customer needs to varify OTP
  # status of 202 customer already validated show variant page
  # status of 406 customer already registered for this raffle
  # status of 403 customer participant chance if -1
  def send_otp
    customer = find_customer_by_email_id
    return if !validate_email_for_already_registered_or_customer_chance_over customer

    if !customer.verified
      customer_dix_digit_otp = create_or_update_customer_verification customer
      Mailer::Email.send_otp_mail customer.email_id, customer_dix_digit_otp
      head 200
    else
      head 202
    end
  end

  # status of 200 valid OTP
  # status of 406 OTP expired
  # status of 401 wrong OTP
  def verify_otp
    customer = find_customer_by_email_id_for_verify_otp
    decrypted_data = decrypt_customer_otp_from_db customer
    if decrypted_data == verification_params_for_verify_otp[:code]
      customer_expiration_date_time = find_customer_verification_code_expiration_date_time customer
      if customer_expiration_date_time.localtime >= DateTime.now.in_time_zone
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

  def create_or_update_customer_verification customer
    random_six_digit_number = SecureRandom.random_number(999999).to_s
    customer_verification = customer.verification
    if customer_verification.nil?
      create_verification(random_six_digit_number, customer.id)
    else
      customer_verification.code = random_six_digit_number
      customer_verification.save
    end
    return random_six_digit_number
  end

  def validate_email_for_already_registered_or_customer_chance_over customer
    if validate_if_customer_already_registered customer
      head 406
      return false
    end
    if customer.default_participant_chance.negative?
      head 403
      return false
    end
    return true
  end

  def create_verification(random_six_digit_number, customer_id)
    Verification.create(
      code: random_six_digit_number,
      customer_id: customer_id
    )
  end

  def decrypt_customer_otp_from_db customer
    crypt = ActiveSupport::MessageEncryptor.new(ENV['KEY'])
    return crypt.decrypt_and_verify(customer.verification.code)
  end

  def verify_customer_otp_valid customer
    crypt = ActiveSupport::MessageEncryptor.new(ENV['KEY'])
    decrypted_data = crypt.decrypt_and_verify(customer.verification.code)
    if decrypted_data == verification_params_for_verify_otp[:code]
      customer_expiration_date_time = find_customer_verification_code_expiration_date_time customer
      if customer_expiration_date_time.localtime >= DateTime.now.in_time_zone
        customer.verified = true
        customer.save
        return true
      end
    end
  end

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

  def find_customer_by_email_id_for_verify_otp
    Customer.find_by(email_id: verification_params_for_verify_otp[:email_id])
  end

  def verification_params_for_send_otp
    params.permit(:email, :shopify_product_id)
  end

  def verification_params_for_verify_otp
    params.permit(:code, :email_id)
  end
end