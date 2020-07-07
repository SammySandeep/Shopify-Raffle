# frozen_string_literal: true

class RafflesController < HomeController
  def index
    @raffles = Raffle.all
  end

  def show
    @raffle = Raffle.find(params[:id])
  end

  def show_winner_runner
    winner = Result.find_by(raffle_id: params[:id], type_of_customer: 'winner')
    @winner_customer = Customer.find(winner.customer_id)
    runners_results = Result.where(raffle_id: params[:id], type_of_customer: 'runner')
    @runner_customers = find_runner_customers runners_results
  end

  private

  def find_runner_customers runners_results
    runner_customers = Array.new
    runners_results.each do |runner|
      runner_customers.push(Customer.find(runner.customer_id))
    end
    return runner_customers
  end

  def raffle_params
    params.permit
  end
end
