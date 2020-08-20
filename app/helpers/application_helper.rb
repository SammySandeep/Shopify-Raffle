module ApplicationHelper
    
  def session_activate shop
     session = ShopifyAPI::Session.new(domain: shop.shopify_domain, token: shop.shopify_token, api_version: '2020-04')
     ShopifyAPI::Base.activate_session(session)
  end  
  
  def shop session
    Shop.find_by(shopify_domain: session['shopify.omniauth_params']['shop'])
  end

end
