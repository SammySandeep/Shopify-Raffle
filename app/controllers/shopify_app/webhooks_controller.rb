# frozen_string_literal: true

class ShopifyApp::WebhooksController < ApplicationController
  include ShopifyApp::WebhookVerification
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :verify_webhook, raise: false

  def products_info
    @webhook_params = params.permit!
    head :ok
    return if params[:tags].nil?

    @tags = params[:tags].split(',').collect { |tag| tag.strip.downcase }
    return unless @tags.include?('raffle') && @tags.any? { |tag| tag.include? 'launch' }

    @product_local = Product.find_by(shopify_product_id: params[:id], status: 'pending')
    if @product_local.nil?
      product_create
    else
      @product_local.shopify_product_id = params[:id]
      @product_local.shopify_product_title = params[:title]
      @product_local.has_variant = (params[:variants].count.positive? and params[:variants].first[:title] != 'Default Title')
      @product_local.save
      params[:variants].each do |variant|
        @variant = Variant.find_by(shopify_variant_id: variant[:id])
        # Raffle.find_by(title: 'PID' + params[:id].to_s + '-' + params[:title].gsub(' ', '') + '-VID' + variant[:id].to_s + '-' + 'DefaultTitle')
        if @variant.nil?
          @variant_saved = Variant.create(
            title: variant[:title],
            shopify_variant_id: variant[:id],
            product_id: @product_local.id,
            inventory_quantity: variant[:inventory_quantity]
          )
          Raffle.create(
            title: params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', ''),
            launch_date_time: DateTime.civil(@launch_date[2].to_i, @launch_date[0].to_i, @launch_date[1].to_i, @launch_date[3].to_i, @launch_date[4].to_i),
            delivery_method: @tags.include?('online') ? 'online' : 'offline',
            variant_id: @variant_saved.id
          )
        else
          @variant.title = variant[:title]
          @variant.product_id = @product_local.id
          @variant.inventory_quantity = variant[:inventory_quantity]
          @raffle = Raffle.find_by(variant_id: @variant.id)
          @tags.each do |tag|
            if tag.include?('launch')
              @launch_date = tag.gsub(/[^\d-]/, '').split('-').reject(&:empty?)
              break
            end
          end
          if @raffle.nil?
            Raffle.create(
              title: params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', ''),
              launch_date_time: DateTime.civil(@launch_date[2].to_i, @launch_date[0].to_i, @launch_date[1].to_i, @launch_date[3].to_i, @launch_date[4].to_i),
              delivery_method: @tags.include?('online') ? 'online' : 'offline',
              variant_id: @variant.id
            )
          else
            @raffle.title = params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', '')
            @raffle.launch_date_time = DateTime.civil(@launch_date[2].to_i, @launch_date[0].to_i, @launch_date[1].to_i, @launch_date[3].to_i, @launch_date[4].to_i)
            @raffle.delivery_method = @tags.include?('online') ? 'online' : 'offline'
            @raffle.save
          end
        end
      end
    end
  end

  private

  def product_create
    @product = Product.create(
      shopify_product_id: params[:id],
      shopify_product_title: params[:title],
      has_variant: (params[:variants].count.positive? and params[:variants].first[:title] != 'Default Title'),
      shop_id: shop_get.id,
      status: 'pending'
    )
    variant_raffle_create(@product.id)
  end

  def variant_raffle_create(product_id)
    @tags.each do |tag|
      if tag.include?('launch')
        @launch_date = tag.gsub(/[^\d-]/, '').split('-').reject(&:empty?)
        break
      end
    end
    params[:variants].each do |variant|
      @variant = Variant.create(
        title: variant[:title],
        shopify_variant_id: variant[:id],
        product_id: product_id,
        inventory_quantity: variant[:inventory_quantity]
      )
      Raffle.create(
        title: params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', ''),
        launch_date_time: DateTime.civil(@launch_date[2].to_i, @launch_date[0].to_i, @launch_date[1].to_i,
                                         @launch_date[3].to_i, @launch_date[4].to_i),
        delivery_method: @tags.include?('online') ? 'online' : 'offline',
        variant_id: @variant.id
      )
    end
  end

  def shop_get
    Shop.find_by(shopify_domain: shop_domain)
  end
end
