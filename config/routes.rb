# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  get 'contents/home'
  root to: 'home#index'
  resources :settings
  mount ShopifyApp::Engine, at: '/'

  get 'raffles', to: 'raffles#index'
  get 'raffles/participant_customers/:id', to: 'raffles#participant_customers', as: 'raffle_participant_customers'
  get 'raffles/winner_and_runner_customers/:id', to: 'raffles#winner_and_runner_customers', as: 'winner_and_runner_customers'

  namespace :app_proxy do
    get 'verifications/send_otp', to: 'verifications#send_otp'
    get 'verifications/verify_otp', to: 'verifications#verify_otp'
    get 'registrations/register_customer', to: 'registers#register_customer'
  end

  get 'raffles/send_mail_to_winner/:id', to: 'raffles#send_mail_to_winner', as: 'raffle_send_mail_to_winner'
  get 'raffles/send_mail_to_runner/:id', to: 'raffles#send_mail_to_runner', as: 'raffle_send_mail_to_runner'
  get 'raffles/send_mail_to_participants/:id', to: 'raffles#send_mail_to_participants', as: 'raffle_send_mail_to_participants'
  get 'links/expiration', to: 'links#expiration', as: 'links_expiration'
  get 'links/index', to: 'links#index', as: 'links'
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
