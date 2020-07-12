
class Address < ApplicationRecord
  before_save :create_result

  belongs_to :customer

  validates :address, presence: true
  validates :address, format: { with: /[a-zA-Z]/ }
  validates :city, presence: true
  validates :city, format: { with: /[a-zA-Z]/ }
  validates :country, presence: true
  validates :country, format: { with: /[a-zA-Z]/ }
  validates :state, presence: true
  validates :state, format: { with: /[a-zA-Z]/ }
  validates :pin, numericality: { greater_than: 0 }, presence: true
  validates :customer_id, numericality: { greater_than: 0 }, presence: true

  private

  def create_result
    Result.create(
      raffle_id: self.raffle_id,
      customer_id: self.customer_id,
      type_of_customer: 'participant'
    )
  end
end
