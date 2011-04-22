# encoding: utf-8

class BlogImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  # Override the directory where uploaded files will be stored.
  def store_dir
    ENV['MONGOHQ_URL'] ? "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}" : "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :small do
    process :resize_to_limit => [200, 200]
  end

  version :content do
    process :resize_to_limit => [300, 300]
  end

  version :thumb do
    process :resize_to_limit => [250, 188]
  end

end
