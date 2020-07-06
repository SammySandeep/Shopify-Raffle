class Sync::Customers
  include Sidekiq::Worker

  def perform
    session_activate(self)
        begin
            store_customers = ShopifyAPI::Customer.find(:all, params: {limit: 250})
            customers = Array.new
                loop do
                    customers += store_customers
                    break unless store_customers.next_page?
                
                    store_customers = store_customers.fetch_next_page
                end
        rescue StandardError
          retry
        end  
    sync_customers customers 
   end

   private

    def sync_customers customers
        customers.each do |customer|
            Customer.create(
            shopify_customer_id: customer.id,
            first_name: customer.first_name,
            last_name: customer.last_name,
            email_id: customer.email,
            shop_id: self.id
            )
        end
    end

end