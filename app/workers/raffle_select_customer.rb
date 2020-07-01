# frozen_string_literal: true

class RaffleSelectCustomer
  include Sidekiq::Worker

  def perform
    Product.where(status: 'pending').each do |product|
      product.variants.each do |variant|
        variant.raffles.each do |raffle|
          # binding.pry
          if DateTime.now.change(sec: 0, offset: 0) == raffle.launch_date_time
            # binding.pry
            select_winner(raffle)
          end
        end
      end
    end
  end

  private

  def select_winner(raffle)
    customers = raffle.customers
    return if customers.empty?

    winner_customers = []
    number_of_runners = Setting.first.number_of_runner

    while winner_customers.count < number_of_runners
      customer = customers.sample
      next if winner_customers.include? customer.id

      winner_customers.push(customer.id)

      break if winner_customers.count == customers.count
    end
    # binding.pry
    result = Result.find_by(customer_id: winner_customers.first, raffle_id: raffle.id)
    result.type_of_customer = 'winner'
    result.save
    winner_customers.each_with_index do |customer_id, index|
      next if index.zero?

      result = Result.find_by(customer_id: customer_id, raffle_id: raffle.id)
      result.type_of_customer = 'runner'
      result.save
    end
  end
end
