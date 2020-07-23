class LinksController < ApplicationController
    def index
    end
    
    def expiration
        @raffle_id = params[:raffle_id]
        @customer_id = params[:customer_id]
        @result = Result.find_by(raffle_id: @raffle_id, customer_id: @customer_id)
        @result_id = @result.id
        @notification = Notification.find_by(result_id: @result_id)
        @notification_created_at = @notification.created_at
        @time_in_hour = Setting.first.purchase_window
        @current_time = DateTime.now.utc
        @actual_time = @notification_created_at + @time_in_hour.hours
        
        if @actual_time < @current_time
        
            redirect_to links_path, notice: 'We are very sorry.You have expired your link' 

        else

            @raffle = Raffle.find_by(id: @raffle_id)
            @var_id = @raffle.variant_id
            @shopify_variant = Variant.find_by(id: @var_id)
            shopify_variant_id = @shopify_variant.shopify_variant_id
            quantity = 1
            customer_email = Customer.find_by(id: @customer_id).email_id
            customer_first_name = Customer.find_by(id: @customer_id).first_name
            customer_last_name = Customer.find_by(id: @customer_id).last_name
            @customer_address = Address.find_by(customer_id: @customer_id, raffle_id: @raffle_id)
            customer_address1 = @customer_address.address
            customer_address_city = @customer_address.city
            customer_address_zipcode = @customer_address.pin
            shop_domain = Shop.first.shopify_domain
            @url = "http://#{shop_domain}/cart/#{shopify_variant_id}:#{quantity}?checkout[email]=#{customer_email}&checkout[shipping_address][first_name]=#{customer_first_name}&checkout[shipping_address][last_name]=#{customer_last_name}&checkout[shipping_address][address1]=#{customer_address1}&checkout[shipping_address][city]=#{customer_address_city}&checkout[shipping_address][zip]=#{customer_address_zipcode}"
            redirect_to(@url)
        end





    
    end

end
