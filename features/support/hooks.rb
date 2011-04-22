Before('@admin') do
  Capybara.default_host = Rails.application.config.admin_host
  Capybara.app_host = "http://#{Rails.application.config.admin_host}" if Capybara.current_driver == :culerity
end