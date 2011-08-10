if Rails.env.development?
  ActionMailer::Base.smtp_settings = {  
    :address => "localhost",
    :port => 1025,
    :user_name => "xxxx",
    :password => "xxxx",
    :authentication => :plain,
    :enable_starttls_auto => false
  }
end