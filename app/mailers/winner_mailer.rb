class WinnerMailer < ApplicationMailer
    # def send_runner_mail()

    # end
    def send_winner_mail(winner_full_name,product_title,winner_email)
        @body = Setting.first.email_body_for_winner
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


    
end
