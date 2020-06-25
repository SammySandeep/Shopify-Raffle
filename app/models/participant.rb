# frozen_string_literal: true

class Participant < ApplicationRecord
  has_many :raffles
  has_many :customers

  validates :raffle_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
  validates :customer_id, format: { with: /\A\d+\z/ }, numericality: { greater_than: 0 }, presence: true
end
