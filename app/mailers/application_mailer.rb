class ApplicationMailer < ActionMailer::Base
  default from: "notifications@twistbooks.com"
  layout 'mailer'
end
