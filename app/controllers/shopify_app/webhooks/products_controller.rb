
class ShopifyApp::Webhooks::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :product_params, only: %i[create update]

  def create
    if product_eligible_for_raffle
      product = create_product
      create_variants(product)
    end
    head :ok
  end

  def update
    # product_local change to @product
    @product = Product.find_by(shopify_product_id: product_params[:id], status: 'pending')

    if @product.nil?
      if product_eligible_for_raffle
        product = create_product
        create_variants(product)
      end
      head :ok
      return
    end
    @product.shopify_product_title = product_params[:title]
    @product.has_variant = product_params[:variants].first[:title] != 'Default Title'
    @product.save

    product_params[:variants].each do |variant|
      @variant = Variant.find_by(shopify_variant_id: variant[:id])
      if @variant.nil?
        variant = create_variant(variant, @product.id)
        create_raffle(variant)
      else
        @variant.title = variant[:title]
        @variant.product_id = @product.id
        @variant.inventory_quantity = variant[:inventory_quantity]
        @variant.save
        @raffle = find_raffle_by_variant_id(@variant.id)
        @tags = product_params[:tags].split(',').collect { |tag| tag.strip.downcase }
        launch_date = manipulate_launch_date
        @raffle.title = product_params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', '')
        @raffle.launch_date_time = DateTime.civil(launch_date[2].to_i, launch_date[0].to_i, launch_date[1].to_i, launch_date[3].to_i, launch_date[4].to_i)
        @raffle.delivery_method = @tags.include?('online') ? 'online' : 'offline'
        @raffle.save
      end
    end
    head :ok
  end

  private

  def find_raffle_by_variant_id(variant_id)
    Raffle.find_by(variant_id: variant_id)
  end

  def create_variants(product)
    product_params[:variants].each do |variant|
      variant = create_variant(variant, product.id)
      create_raffle(variant)
    end
  end

  def create_variant(variant, product_id)
    Variant.create(
      title: variant[:title],
      shopify_variant_id: variant[:id],
      product_id: product_id,
      inventory_quantity: variant[:inventory_quantity]
    )
  end

  def manipulate_launch_date
    @tags.each do |tag|
      if tag.include?('launch')
        return tag.gsub(/[^\d-]/, '').split('-').reject(&:empty?)
      end
    end
  end

  def product_eligible_for_raffle
    if !product_params[:tags].nil?
      @tags = product_params[:tags].split(',').collect { |tag| tag.strip.downcase }
      if @tags.include?('raffle') && @tags.any? { |tag| tag.include? 'launch' } && (@tags.include?('online') || @tags.include?('offline'))
        return true
      end
    end
    return false
  end

  def create_product
    Product.create(
      shopify_product_id: product_params[:id],
      shopify_product_title: product_params[:title],
      has_variant: product_params[:variants].first[:title] != 'Default Title',
      shop_id: get_shop_id,
      status: 'pending'
    )
  end



  def create_raffle(variant)
    launch_date = manipulate_launch_date
    Raffle.create(
      title: product_params[:title].gsub(' ', '') + '_' + variant[:title].gsub(' ', ''),
      launch_date_time: DateTime.civil(launch_date[2].to_i, launch_date[0].to_i, launch_date[1].to_i,
        launch_date[3].to_i, launch_date[4].to_i),
      delivery_method: @tags.include?('online') ? 'online' : 'offline',
      variant_id: variant.id
    )
  end

  def get_shop_id
    Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']).id
  end

  def product_params
    params.permit(:id, :title, :tags, variants: %i[id title inventory_quantity]).to_h
  end

end
