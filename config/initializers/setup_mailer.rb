ActionMailer::Base.smtp_settings = {
    :user_name => ENV["EMAIL_API"],
    :password => ENV["EMAIL_PWD"],
    :domain => ENV["DOMAIN"],
    :address => ENV["EMAIL_SMTP"],
    :port => 587,
    :authentication => "plain",
    :enable_starttls_auto => true
}