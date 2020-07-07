class RafflesController < HomeController
    def index
      @shop = Shop.find_by(shopify_domain: session['shopify.omniauth_params']['shop'])
      @raffles = @shop.raffles
    end
  
    def show
      @raffle = Raffle.find(params[:id])
    end
  end