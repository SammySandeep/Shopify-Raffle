class NotifyMailer < ApplicationMailer

    def winner(product_title, raffle, winner_customer, url, body)
        @body = body
        @url = url
        winner_customer_name = winner_customer.first_name + ' ' + winner_customer.last_name
        @delivery_method = raffle.delivery_method
        @body = @body.gsub "{Your customer name will be replaced here}",winner_customer_name
        @body = @body.gsub "{Raffle products will be replaced here}",product_title
        @body = @body.gsub ' ', '&nbsp;'
        @body = @body.gsub "\t", ' &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '
        mail to: "#{winner_customer.email_id}", subject: "Congratulations!" 
    end

    def participants(product_title, raffle, customer, body)
        @body = body
        customer_full_name = customer.first_name + ' ' + customer.last_name
        @body = @body.gsub "{Your customer name will be replaced here}",customer_full_name
        @body = @body.gsub "{Raffle products will be replaced here}",product_title
        @body = @body.gsub ' ', '&nbsp;'
        @body = @body.gsub "\t", ' &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '
        mail to: "#{customer.email_id}", subject: "Better Luck Next Time!" 
    end

    def otp(customer_mail, six_digit_otp, body)
        @body = body
        @body = @body + six_digit_otp.to_s
        mail to: customer_mail, subject: 'OTP'
    end

    def raffle_participation_confirmation(customer, product_title, body)
        customer_name = customer.first_name + ' ' + customer.last_name
        @body = body
        @body = @body.gsub "{Your customer name will be replaced here}",customer_name
        @body = @body.gsub "{Raffle products will be replaced here}",product_title
        @body = @body.gsub ' ', '&nbsp;'
        @body = @body.gsub "\t", ' &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '
        mail to: "#{customer.email_id}", subject: "Raffle Registration Confirmation!" 
    end

end