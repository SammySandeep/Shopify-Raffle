# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  get 'contents/home'
  root to: 'home#index'
  resources :settings
  mount ShopifyApp::Engine, at: '/'

  get 'raffles', to: 'raffles#index'
  get 'raffles/show_participant_customers/:id', to: 'raffles#show_participant_customers', as: 'raffle_show_participant_customers'
  get 'raffles/show_winner_and_runner_customers/:id', to: 'raffles#show_winner_and_runner_customers', as: 'show_winner_and_runner_customers'

  namespace :app_proxy do
    get 'verifications/send_otp', to: 'verifications#send_otp'
    get 'verifications/verify_otp', to: 'verifications#verify_otp'
    get 'registrations/register_customer', to: 'registers#register_customer'
  end

  get 'raffles/send_mail_winner/:id', to: 'raffles#send_mail_winner', as: 'raffle_send_mail_winner'
  get 'raffles/send_mail_runner/:id', to: 'raffles#send_mail_runner', as: 'raffle_send_mail_runner'
  get 'raffles/send_mail_participants/:id', to: 'raffles#send_mail_participants', as: 'raffle_send_mail_participants'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/shopify_app/webhooks/create', to: 'shopify_app/webhooks/products#create'
  post '/shopify_app/webhooks/update', to: 'shopify_app/webhooks/products#update'
  post '/shopify_app/webhooks/destroy_only_pending_raffle', to: 'shopify_app/webhooks/products#destroy_only_pending_raffle'
  post '/shopify_app/webhooks/order_upadte_participant_chance', to: 'shopify_app/webhooks/orders#order_upadte_participant_chance'
  post '/shopify_app/webhooks/create_customer', to: 'shopify_app/webhooks/customers#create_customer'
  post '/shopify_app/webhooks/update_customer', to: 'shopify_app/webhooks/customers#update_customer'
  post '/shopify_app/webhooks/delete_customer', to: 'shopify_app/webhooks/customers#delete_customer'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
  
end
