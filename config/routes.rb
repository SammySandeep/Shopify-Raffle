# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'home#index'
  resources :settings
  mount ShopifyApp::Engine, at: '/'

  get 'raffles', to: 'raffles#index'
  get 'raffles/:id', to: 'raffles#show', as: 'raffle'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/shopify_app/webhooks/create', to: 'shopify_app/webhooks/products#create'
  post '/shopify_app/webhooks/update', to: 'shopify_app/webhooks/products#update'
  post '/shopify_app/webhooks/order_upadte_participant_chance', to: 'shopify_app/webhooks/orders#order_upadte_participant_chance'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN_NAME'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
  
end
