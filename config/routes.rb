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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/shopify_app/webhooks/create', to: 'shopify_app/webhooks/products#create'
  post '/shopify_app/webhooks/update', to: 'shopify_app/webhooks/products#update'
  post '/shopify_app/webhooks/destroy', to: 'shopify_app/webhooks/products#destroy'
  post '/shopify_app/webhooks/order_upadte_participant_chance', to: 'shopify_app/webhooks/orders#order_upadte_participant_chance'
  post '/shopify_app/webhooks/create_customer', to: 'shopify_app/webhooks/customers#create_customer'
  post '/shopify_app/webhooks/update_customer', to: 'shopify_app/webhooks/customers#update_customer'
  post '/shopify_app/webhooks/delete_customer', to: 'shopify_app/webhooks/customers#delete_customer'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN_NAME'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
  
end
