# frozen_string_literal: true

ShopifyApp.configure do |config|
  config.application_name = 'My Shopify App'
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ''
  config.scope = 'read_products,read_customers,read_orders' # Consult this page for more scope options:
  # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = '2020-04'
  config.shop_session_repository = 'Shop'
  config.webhooks = [
    { topic: 'products/create', address: "#{ENV['URL']}/shopify_app/webhooks/create", format: 'json' },
    { topic: 'products/update', address: "#{ENV['URL']}/shopify_app/webhooks/update", format: 'json' },
    { topic: 'products/delete', address: "#{ENV['URL']}/shopify_app/webhooks/destroy_only_pending_raffle", format: 'json' },
    { topic: 'customers/create', address: "#{ENV['URL']}/shopify_app/webhooks/create_customer", format: 'json' },
    { topic: 'customers/update', address: "#{ENV['URL']}/shopify_app/webhooks/update_customer", format: 'json' },
    { topic: 'customers/delete', address: "#{ENV['URL']}/shopify_app/webhooks/delete_customer", format: 'json' }
    ]
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known