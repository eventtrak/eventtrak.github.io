Audience::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Add the fonts path
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # Precompile additional assets
  config.assets.precompile += %w( .svg .eot .woff .ttf )

  # Print original SASS location in output
  config.sass.debug_info = true
  config.sass.line_comments = true

  # Mailer config
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :port           => 587,
    :address        => 'smtp.mailgun.org',
    :user_name      => 'postmaster@app18252660.mailgun.org',
    :password       => '69llc9ng1il5',
    :domain         => 'app18252660.mailgun.org',
    :authentication => :plain,
  }
  # config.action_mailer.smtp_settings = {
  #   address:              'oxmail.registrar-servers.com',
  #   port:                 587,
  #   domain:               'tunetap.com',
  #   user_name:            'thetap@tunetap.com',
  #   password:             '!TT3870',
  #   authentication:       'login',
  #   enable_starttls_auto: true 
  # }
  # config.action_mailer.smtp_settings = {
  #   address:              'smtp.gmail.com',
  #   port:                 587,
  #   domain:               'tunetap.com',
  #   user_name:            'inspire48@gmail.com',
  #   password:             '',
  #   authentication:       'plain',
  #   enable_starttls_auto: true
  # }
end
