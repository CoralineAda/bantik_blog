class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include BantikBlog::Base

  # Attributes =====================================================================================
  field :title
  field :content
  field :tags, :type => Array
  field :slug
  field :author
  field :published_at, :type => Date
  field :state
  field :publication_date, :type => DateTime
  field :summary
  field :allow_comments, :type => Boolean, :default => true
  field :featured, :type => Boolean, :default => false
  field :featured_image_id

  # Indices ========================================================================================
  index :slug, :unique => false
  index :state, :unique => false

  # Constants ======================================================================================
  FILTERS = [
    {:scope => "all",       :label => "All"},
    {:scope => "published", :label => "Published"},
    {:scope => "drafts",    :label => "Drafts"}
  ]
  STATES = ['draft', 'published']

  # Scopes =========================================================================================
  scope :drafts,      :where => {:state => 'draft'}
  scope :published,   :where => {:state => 'published'}, :descending => :publication_date
  scope :by_slug, lambda {|slug| {:where => {:slug.in => ["#{slug}".gsub('//','/'), "/#{slug}/".gsub('//','/'), "/#{slug}"] } } }
  scope :featured, :where => { :featured => true }

  # Relationships ==================================================================================
  referenced_in :blog, :inverse_of => :posts
  referenced_in :topic, :inverse_of => :posts
  has_many :comments

  # Behavior =======================================================================================
  attr_accessor :desired_slug
  has_slug :desired_slug

  # Callbacks ======================================================================================

  # Validations ====================================================================================

  class DesiredSlugPresenceAndUniquenessValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      object.desired_slug = "#{object.title}" unless object.desired_slug
      if object.blog && object.blog.posts.map{|p| p.slug unless p == object}.include?(object.desired_slug)
        object.errors[attribute] << (options[:message] || "must be unique.")
      end
    end
  end

  class SelectedTopicIsSubtopicValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      if object.topic && object.topic.root? && object.blog.has_subtopics?
        object.errors[attribute] << (options[:message] || "must be a subtopic.")
      end
    end
  end

  validates :desired_slug, :desired_slug_presence_and_uniqueness => true
  validates :topic, :selected_topic_is_subtopic => true
  validates_presence_of :title
  validates_presence_of :content

  # Class methods ==================================================================================

  #FIXME
  def self.popular_this_week
    []
  end

  # Instance methods ===============================================================================

  def draft?
    self.state == 'draft' || self.state.nil?
  end

  def featured_image
    return unless self.featured_image_id
    Ckeditor::Asset.find(self.featured_image_id)
  end

  def full_path
    if self.topic
      "#{self.topic.humanize_path}#{self.humanize_path}".gsub('//','/')
    elsif self.blog.use_nested_paths?
      "#{self.blog.humanize_path}#{self.humanize_path}".gsub('//','/')
    else
      "#{self.humanize_path}".gsub('//','/')
    end
  end

  def humanize_path
    "/#{self.slug}/".gsub(/\/\//,'/').gsub(/\/\//,'/')
  end

  def my_index
    self.blog.posts.index(self)
  end

  def next_post
    i = self.my_index + 1
    i = 0 if i > (self.blog.posts.size - 1)
    self.blog.posts.published[i]
  end

  def permalink
    "http://#{Rails.application.config.main_host}#{self.full_path}/"
  end

  def previous_post
    i = self.my_index - 1
    i = self.blog.posts.size - 1 if i < 0
    self.blog.posts.published[i]
  end

  def publish!
    self.update_attributes(:state => 'published', :publication_date => self.publication_date || Time.zone.now)
  end

  def published?
    self.state == 'published'
  end

  # Returns other posts with same tags; functionality from mongoid_taggable gem.
  def related
    self.tags_array.map{|t| self.blog.posts.published.tagged_with(t) - [self]}.flatten
  end

  def unpublish!
    self.update_attributes(:state => 'draft', :publication_date => nil)
  end

  def state=(arg)
    self[:state] = arg.downcase
  end

  def status
    self.state ? self.state.capitalize : 'Draft'
  end

  def topic_name
    self.topic.full_name if self.topic
  end

end
