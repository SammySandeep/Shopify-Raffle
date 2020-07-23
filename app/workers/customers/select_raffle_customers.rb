# frozen_string_literal: true

class Customers::SelectRaffleCustomers
  include Sidekiq::Worker

  def perform
    # add one more loop for shop through get products
    Product.where(status: 'pending').each do |product|
      product.variants.each do |variant|
        raffle = variant.raffle
        if DateTime.now.change(sec: 0, offset: 0) >= raffle.launch_date_time && !Setting.first.nil?
          do_raffle(raffle)
        end
      end
      check_raffle_end_and_update_product_status product
    end
  end

  private

  def check_raffle_end_and_update_product_status product
    product_raffle_completed = true
    product.variants.each do |variant|
      if variant.raffle.launch_date_time > DateTime.now.change(sec: 0, offset: 0)
        product_raffle_completed = false
        break
      end
    end
    if product_raffle_completed
      product.status = 'completed'
      product.save
    end
  end

  def do_raffle(raffle)
    customers = raffle.customers
    return if customers.empty?

    number_of_runners = Setting.first.number_of_runner
    if number_of_runners.nil?
      return false
    end
    raffle_customers = select_customers_for_raffle(customers, number_of_runners)
    update_for_selected_customer_as_winner(raffle_customers.first, raffle.id)

    make_runner_excluding_first_selected_customer(raffle_customers, raffle)
  end

  def make_runner_excluding_first_selected_customer(raffle_customers, raffle)
    raffle_customers.each_with_index do |customer_id, index|
      if index.zero?
        next
      end

      result = Result.find_by(customer_id: customer_id, raffle_id: raffle.id)
      result.type_of_customer = 'runner'
      result.save
    end
  end

  def update_for_selected_customer_as_winner(customer_id, raffle_id)
    result = get_result(customer_id, raffle_id)
    result.type_of_customer = 'winner'
    result.save
  end

  def select_customers_for_raffle(customers, number_of_runners)
    selected_customers = Array.new
    while selected_customers.count <= number_of_runners
      customer = customers.sample
      next if selected_customers.include? customer.id

      selected_customers.push(customer.id)
      break if selected_customers.count == customers.count
    end
    return selected_customers
  end

  def get_result(customer_id, raffle_id)
    Result.find_by(customer_id: customer_id, raffle_id: raffle_id)
  end

end
