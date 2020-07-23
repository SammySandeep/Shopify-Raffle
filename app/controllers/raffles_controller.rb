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
    if winner.nil?
      redirect_to raffles_path, notice: 'No winner found for this raffle!'
    else
      @winner_customer = find_winner_customer winner.customer_id
      runners_results = find_runner_customer_by_raffle_id_and_type_of_customer
      @runner_customers = find_customers runners_results
    end
  end

  def send_mail_runner
    raffle_id = params[:raffle_id]
    customer_id = params[:customer_id]
    @result_id = Result.find_by(raffle_id: raffle_id, customer_id: customer_id).id
    @raffle = Raffle.find_by(id: raffle_id)
    
    if Notification.exists?(:result_id => @result_id)
      redirect_to show_winner_and_runner_customers_path(raffle_id), notice: 'Mail Already Triggered to this customer!'
    else
      Notification.create(result_id: @result_id,notified: true)
      @raffle.variant.inventory_quantity -= 1
      @raffle.variant.save
      var_id = @raffle.variant_id
      product = @raffle.variant.product
      product_title = product.shopify_product_title
      runner_customer = Customer.find_by(id: customer_id)
      runner_customer_name = runner_customer.first_name + ' ' + runner_customer.last_name
      runner_customer_email = runner_customer.email_id
      WinnerMailer.send_winner_mail(runner_customer_name,product_title,runner_customer_email,raffle_id,customer_id).deliver_now
      redirect_to show_winner_and_runner_customers_path(raffle_id), notice: 'Mail Triggered Successfully!'
    end
  end

  def send_mail_winner
    @raffle = Raffle.find(raffle_params[:id])
    raffle_id = @raffle.id
    winner_customer = Result.find_by(raffle_id: @raffle.id, type_of_customer: 'winner')
    @result_id=winner_customer.id
    if Notification.exists?(:result_id => @result_id)
      redirect_to show_winner_and_runner_customers_path(raffle_id), notice: 'Mail Already Triggered to this customer!'
    else
      Notification.create(result_id: @result_id,notified: true)
      @raffle.variant.inventory_quantity -= 1
      @raffle.variant.save
      winner_customer_id = winner_customer.customer_id
      winner_customer_info = Customer.find_by(id: winner_customer_id)
      winner_full_name = winner_customer_info.first_name + ' ' + winner_customer_info.last_name 
      winner_email = winner_customer_info.email_id
      product = @raffle.variant.product
      product_title = product.shopify_product_title
      WinnerMailer.send_winner_mail(winner_full_name,product_title, winner_email,raffle_id,winner_customer_id).deliver_now
      redirect_to show_winner_and_runner_customers_path(raffle_id), notice: 'Mail Triggered Successfully!'
    end
  end

  def send_mail_participants
    @raffle = Raffle.find(raffle_params[:id])
    raffle_id = @raffle.id
    product = @raffle.variant.product
    product_title = product.shopify_product_title
    results_participant = Result.where(raffle_id: raffle_params[:id], type_of_customer: 'participant')
    @participant_customers = find_customers results_participant
    @participant_customers.each do |customer|
      customer_full_name = customer.first_name + ' ' + customer.last_name
      customer_email = customer.email_id
      WinnerMailer.send_participants_mail(customer_full_name,product_title,customer_email).deliver_now
    end
    redirect_to show_winner_and_runner_customers_path(raffle_id), notice: 'Mail Triggered Successfully to all Participants!'
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
