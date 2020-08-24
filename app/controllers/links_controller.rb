class LinksController < HomeController
    include ApplicationHelper
    
    def index
    end

    def expiration
        result = find_result_by_raffle_id_and_customer_id params[:raffle_id], params[:customer_id]
        notification = find_notification_by_result_id result.id
        shop = shop session
        time_in_hour = shop.setting.purchase_window
        current_time = DateTime.now.utc
        actual_time = notification.created_at + time_in_hour.hours
        if actual_time < current_time
            redirect_to links_path, notice: 'We are very sorry.You have expired your link' 
        else
            raffle = find_raffle_by_raffle_id params[:raffle_id] 
            shopify_variant = find_variant_by_id raffle.variant_id
            shopify_variant_id = shopify_variant.shopify_variant_id
            quantity = 1
            customer = find_customer_by_id params[:customer_id]
            customer_email = customer.email_id
            customer_first_name = customer.first_name
            customer_last_name = customer.last_name
            customer_address = find_address_by_customer_id_and_raffle_id params[:customer_id], params[:raffle_id]
            customer_address1 = customer_address.address
            customer_address_city = customer_address.city
            customer_address_zipcode = customer_address.pin
            shop = shop session
            shop_domain = shop.shopify_domain
            @url = "http://#{shop_domain}/cart/#{shopify_variant_id}:#{quantity}?checkout[email]=#{customer_email}&checkout[shipping_address][first_name]=#{customer_first_name}&checkout[shipping_address][last_name]=#{customer_last_name}&checkout[shipping_address][address1]=#{customer_address1}&checkout[shipping_address][city]=#{customer_address_city}&checkout[shipping_address][zip]=#{customer_address_zipcode}"
            redirect_to(@url)
        end
    end

    private

        def find_result_by_raffle_id_and_customer_id raffle_id, customer_id
            Result.find_by(raffle_id: raffle_id, customer_id: customer_id)
        end

        def find_notification_by_result_id result_id
            Notification.find_by(result_id: result_id)
        end

        def find_customer_by_id customer_id
            Customer.find_by(id: customer_id)
        end

        def find_address_by_customer_id_and_raffle_id customer_id, raffle_id
            Address.find_by(customer_id: customer_id, raffle_id: raffle_id)
        end

        def find_raffle_by_raffle_id raffle_id
            Raffle.find_by(id: raffle_id)
        end

        def find_variant_by_id variant_id
            Variant.find_by(id: variant_id)
        end

end