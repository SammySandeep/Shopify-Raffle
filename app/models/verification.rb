class Verification < ApplicationRecord
  before_save :encrypted_customer_key

  belongs_to :customer


  private

  def encrypted_customer_key
    key = ENV['KEY']
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(self.code)
    self.code = encrypted_data
  end
end
