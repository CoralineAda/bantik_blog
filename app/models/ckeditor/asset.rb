require 'mime/types'
require 'carrierwave/orm/mongoid'

class Ckeditor::Asset

  include Mongoid::Document
  include Mongoid::Timestamps

  field :data
  field :data_file_name
  field :data_content_type
  field :data_file_size, :type => Integer
  field :assetable_id, :type => String
  field :assetable_type
  field :kind
  field :guid
  field :locale, :default => 0, :type => Integer

  mount_uploader :data, BlogImageUploader

  before_validation :make_content_type
  before_create :make_dimensions
  has_one :featured_image

  def url(*args)
    data.url(*args)
  end

  alias :public_filename :url

  def filename
    data_file_name
  end

  def content_type
    data_content_type
  end

  def size
    data_file_size
  end

  def path
    data.path
  end

  def styles
    data.styles
  end

  def format_created_at
    I18n.l(self.created_at, :format=>"%d.%m.%Y %H:%M")
  end

  def to_xml(options = {})
    builder = options[:builder] ||= Nokogiri::XML::Builder.new(options)

    builder.send(self.type.to_s.downcase) do |xml|
      xml.id_ self.id
      xml.filename self.filename
      xml.size self.size
      xml.path self.url

      xml.styles do
        self.styles.each do |style|
          xml.send(style.first, self.url(style.first))
        end
      end unless self.styles.empty?
    end

    builder.to_xml
  end

  def has_dimensions?
    self.respond_to?(:width) && self.respond_to?(:height)
  end

  def image?
    ["image/jpeg", "image/tiff", "image/png", "image/gif", "image/bmp"].include?(self.data_content_type)
  end

  def geometry
    @geometry ||= Paperclip::Geometry.from_file(data.to_file)
    @geometry
  end

  private

    def make_dimensions
      if image? && has_dimensions?
        self.width = geometry.width
        self.height = geometry.height
      end
    end

    def make_content_type
      if data_content_type == "application/octet-stream"
        content_types = MIME::Types.type_for(filename)
        self.data_content_type = content_types.first.to_s unless content_types.empty?
      end
    end
end
