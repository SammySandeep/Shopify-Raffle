# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :variant

  has_many :results, dependent: :destroy
  has_many :customers, through: :results

  has_many :addresses, dependent: :destroy

  validates :title, presence: true
  validates :delivery_method, inclusion: { in: ['online', 'offline', nil] }
end
