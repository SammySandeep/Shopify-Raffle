# frozen_string_literal: true

class RafflesController < HomeController
   include ApplicationHelper
  def index
    shop = shop session
    @raffles = Raffle.raffle_products_and_variants shop
  end

  def participant_customers
    @raffle = find_raffle_by_id raffle_params[:id]
    results_participant = take_results_by_raffle_id_and_type_of_customer raffle_params[:id],'participant'
    @participant_customers = take_customers results_participant
  end

  def winner_and_runner_customers
    @raffle = find_raffle_by_id raffle_params[:id]
    winner  = take_results_by_raffle_id_and_type_of_customer raffle_params[:id], 'winner'
    if winner.nil?
      redirect_to raffles_path, notice: 'No winner found for this raffle!'
    else
      @winner_customer = find_winner_customer winner[0].customer_id
      runners_results = take_results_by_raffle_id_and_type_of_customer raffle_params[:id], 'runner'
      @runner_customers = take_customers runners_results
    end
  end

  def send_mail_to_runner
    result = find_result_by_raffle_id_and_customer_id params[:raffle_id], params[:customer_id] 
    raffle = find_raffle_by_id params[:raffle_id] 
    if Notification.exists?(:result_id => result.id)
      redirect_to winner_and_runner_customers_path(params[:raffle_id]), notice: 'Mail Already Triggered to this customer!'
    else
      shop = shop session
      winner_customer = find_customer_by_id params[:customer_id] 
      Raffle.create_notification_and_reduce_quantity result.id, raffle
      Raffle.send_email_for_winner_customer raffle, winner_customer, shop
      redirect_to winner_and_runner_customers_path(params[:raffle_id]), notice: 'Mail Triggered Successfully!'
    end
  end

  def send_mail_to_winner
    raffle =  find_raffle_by_id raffle_params[:id] 
    result = find_results_by_raffle_id_and_type_of_customer raffle.id, 'winner' 
    if Notification.exists?(:result_id => result.id)
      redirect_to winner_and_runner_customers_path(raffle.id), notice: 'Mail Already Triggered to this customer!'
    else
      shop = shop session
      winner_customer = find_customer_by_id result.customer_id 
      Raffle.create_notification_and_reduce_quantity result.id, raffle  
      Raffle.send_email_for_winner_customer raffle, winner_customer, shop
      redirect_to winner_and_runner_customers_path(raffle.id), notice: 'Mail Triggered Successfully!'
    end
  end

  def send_mail_to_participants
    raffle = find_raffle_by_id raffle_params[:id] 
    shop = shop session
    results_participant = take_results_by_raffle_id_and_type_of_customer raffle.id, 'participant'
    participant_customers = take_customers results_participant
    Raffle.send_mail_for_participants raffle, participant_customers, shop 
    redirect_to winner_and_runner_customers_path(raffle.id), notice: 'Mail Triggered Successfully to all Participants!'
  end

  private

  def raffle_params
    params.permit(:id)
  end

  def find_raffle_by_id id
    Raffle.find(id)
  end

  def take_results_by_raffle_id_and_type_of_customer raffle_id, type_of_customer
    Result.where(raffle_id: raffle_id, type_of_customer: type_of_customer)
  end
  
  def find_result_by_raffle_id_and_customer_id raffle_id , customer_id
    Result.find_by(raffle_id: raffle_id, customer_id: customer_id)
  end

  def find_results_by_raffle_id_and_type_of_customer raffle_id, type_of_customer
    Result.find_by(raffle_id: raffle_id, type_of_customer: type_of_customer)
  end

  def find_raffle_by_id raffle_id
    Raffle.find_by(id: raffle_id)
  end

  def find_customer_by_id customer_id
    Customer.find_by(id: customer_id)
  end

  def find_winner_customer customer_id
    Customer.find(customer_id)
  end

  def take_customers results
    runner_customers = Array.new
    results.each do |runner|
      runner_customers.push(Customer.find(runner.customer_id))
    end
    return runner_customers
  end

end
