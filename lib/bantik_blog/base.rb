module BantikBlog

  module Base

    @@sluggable_attribute = nil

    module ClassMethods
      def has_slug(attr)
        self.send(:set_callback, :save, :before, Proc.new{|doc| doc.make_slug})
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def make_slug
      if self.desired_slug && ! self.desired_slug.blank?
        text = "#{self.desired_slug}"
      elsif self.slug
        text = self.slug
      elsif self.respond_to?(:page_title)
        text = "#{self.page_title.to_s.downcase}"
      elsif self.respond_to?(:name)
        text = "#{self.name.to_s.downcase}"
      end

      # Translation borrowed from permalink_fu
      text = text.to_s
      text.gsub!(/[^\x00-\x7F]+/, '-')    # Remove anything non-ASCII entirely (e.g. diacritics).
      text.gsub!(/[^\/\w_ \-]+/i,   '-')  # Remove unwanted chars.
      text.gsub!(/[ \-]+/i,      '-')     # No more than one of the separator in a row.
      text.gsub!(/^\-|\-$/i,      '')     # Remove leading/trailing separator.
      text.downcase!
      self.slug = text

    end

  end

end