# frozen_string_literal: true

class Result < ApplicationRecord

  belongs_to :customer
  belongs_to :raffle
  has_one :notification

end
