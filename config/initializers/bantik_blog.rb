# Replace with appropriate keys for your host application
Recaptcha.configure do |config|
  config.public_key  = '6LfyYcASAAAAAAvXdvwrzG3tvJZ-nY4X6G1IAKa8'
  config.private_key = '6LfyYcASAAAAAPL1957fMiE_pUm0GjUcGBL_Rvx7'
end

GravatarImageTag.configure do |config|
  # Set this to use your own default gravatar image rather then serving up Gravatar's default image [ 'http://example.com/images/default_gravitar.jpg', :identicon, :monsterid, :wavatar, 404 ].
  if Rails.env == 'development'
    config.default_image = "http://#{Rails.application.config.main_host}:3000/images/icons/default_gravatar.png"
  else
    config.default_image = "http://#{Rails.application.config.main_host}/images/icons/default_gravatar.png"
  end
  config.filetype      = nil   # Set this if you require a specific image file format ['gif', 'jpg' or 'png'].  Gravatar's default is png
  config.rating        = nil   # Set this if you change the rating of the images that will be returned ['G', 'PG', 'R', 'X']. Gravatar's default is G
  config.size          = '50'   # Set this to globally set the size of the gravatar image returned (1..512). Gravatar's default is 80
  config.secure        = false # Set this to true if you require secure images on your pages.
end