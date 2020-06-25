# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :shop

  validates :email_body_for_winner, presence: true
  validates :email_body_for_participant, presence: true
  validates :email_body_for_registration, presence: true
  validates :email_body_for_customer_registration_verification, presence: true
  validates :purchase_window, presence: true
  validates :shop_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :purchase_window, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
end
