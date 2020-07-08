# frozen_string_literal: true

class RafflesController < HomeController
  def index
    shop = Shop.find_by(shopify_domain: session['shopify.omniauth_params']['shop'])
    products = shop.products
    @raffles = Array.new
    products.each do |product|
      product.variants.each do |variant|
        @raffles.push(variant.raffle)  
      end
    end
  end

  def show_participant_customers
    @raffle = Raffle.find(raffle_params[:id])
    results_participant = Result.where(raffle_id: raffle_params[:id], type_of_customer: 'participant')
    @participant_customers = find_customers results_participant
  end

  def show_winner_and_runner_customers
    @raffle = Raffle.find(raffle_params[:id])
    winner = find_result_by_raffle_id_and_type_of_customer
    @winner_customer = find_winner_customer winner.customer_id
    runners_results = find_runner_customer_by_raffle_id_and_type_of_customer
    @runner_customers = find_customers runners_results
  end

  private

  def raffle_params
    params.permit(:id)
  end

  def find_runner_customer_by_raffle_id_and_type_of_customer
    Result.where(raffle_id: raffle_params[:id], type_of_customer: 'runner')
  end

  def find_result_by_raffle_id_and_type_of_customer
    Result.find_by(raffle_id: raffle_params[:id], type_of_customer: 'winner')
  end

  def find_winner_customer customer_id
    Customer.find(customer_id)
  end

  def find_customers results
    runner_customers = Array.new
    results.each do |runner|
      runner_customers.push(Customer.find(runner.customer_id))
    end
    return runner_customers
  end

end
