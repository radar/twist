Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  :authentication => :plain,
  :address => "smtp.mailgun.org",
  :port => 587,
  :domain => "twistbooks.com",
  :user_name => "postmaster@twistbooks.com",
  :password => "951647d9da91bdc8bbbc709257578d17"
}
