class Mailer::Email

    def self.send_winner_mail product_title, raffle, winner_customer, url, body
        NotifyMailer.winner(product_title, raffle, winner_customer, url, body).deliver_now
    end

    def self.send_participants_mail product_title, raffle, customer, body
        NotifyMailer.participants(product_title, raffle, customer, body).deliver_now
    end

    def self.send_otp_mail customer_email_id, customer_dix_digit_otp, body
        NotifyMailer.otp(customer_email_id, customer_dix_digit_otp, body).deliver_now    
    end   
    
    def self.send_registration_confirmation_mail customer, product_title, body
        NotifyMailer.raffle_participation_confirmation(customer, product_title, body).deliver_now
    end

end
