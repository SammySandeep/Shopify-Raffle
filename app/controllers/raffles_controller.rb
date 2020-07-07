# frozen_string_literal: true

class RafflesController < HomeController
  def index
    @raffles = Raffle.all
  end

  def show
    @raffle = Raffle.find(params[:id])
  end
end
