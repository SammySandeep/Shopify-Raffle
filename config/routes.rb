# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/shopify_app/webhooks/order_upadte_participant_chance', to: 'shopify_app/webhooks/orders#order_upadte_participant_chance'
end
