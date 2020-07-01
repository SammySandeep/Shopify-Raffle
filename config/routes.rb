# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'

  get 'raffles', to: 'raffles#index'
  get 'raffles/:id', to: 'raffles#show', as: 'raffle'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/shopify_app/webhooks/products_info', to: 'shopify_app/webhooks#products_info'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN_NAME'] && password == ENV['ADMIN_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
end
