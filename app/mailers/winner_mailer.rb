class WinnerMailer < ApplicationMailer
    # def send_runner_mail()

    # end
    def send_winner_mail(winner_full_name,product_title,winner_email,raffle_id,winner_customer_id)
        @body = Setting.first.email_body_for_winner
        @delivery_method = Raffle.find_by(id: raffle_id).delivery_method
        @url="https://c1ae958dccfd.ngrok.io/links/expiration?raffle_id="
        @raffle_id = raffle_id.to_s
        @winner_customer_id = winner_customer_id.to_s
        @url = @url+@raffle_id+"&customer_id="+@winner_customer_id
        @body = @body.gsub "{Your customer name will be replaced here}",winner_full_name
        @body = @body.gsub "{Raffle products will be replaced here}",product_title
        @body = @body.gsub ' ', '&nbsp;'
        @body = @body.gsub "\t", ' &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '
        @email = winner_email
        mail to: "#{@email}", subject: "Congratulations!" 

     
    end
    def send_participants_mail(customer_full_name,product_title,customer_email)
        @body = Setting.first.email_body_for_participant
        @body = @body.gsub "{Your customer name will be replaced here}",customer_full_name
        @body = @body.gsub "{Raffle products will be replaced here}",product_title
        @body = @body.gsub ' ', '&nbsp;'
        @body = @body.gsub "\t", ' &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '
        @email = customer_email
        mail to: "#{@email}", subject: "Better Luck Next Time!" 
    end
    def send_otp_mail(customer_mail, six_digit_otp)
        @body = 'your OTP for raffle is ' + six_digit_otp.to_s
        mail to: customer_mail, subject: 'OTP'
    end
    # def generate_token
    #     @time_in_hour = Setting.first.purchase_window
    #     secret_key = Rails.application.secrets.secret_key_base. to_s
    #     payload = {exp: (Time.zone.now + @time_in_hour.hours).to_i}
    #     token = JWT.encode(payload,secret_key)
    #     return token
    # end
end

