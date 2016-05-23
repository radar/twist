# Be sure to restart your server when you modify this file.

options = {
  key: "_twist_session"
}

case Rails.env
when "development", "test"
  options.merge!(domain: "lvh.me")
when "production"
  # TBA
end

Twist::Application.config.session_store :cookie_store, options
