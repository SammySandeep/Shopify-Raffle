ActionMailer::Base.smtp_settings = {
    :user_name => ENV["EMAIL"],
    :password => ENV["PASSWORD"],
    :domain => ENV["DOMAIN"],
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => "plain",
    :enable_starttls_auto => true
}