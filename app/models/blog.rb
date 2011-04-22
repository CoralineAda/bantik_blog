class Blog
  include Mongoid::Document
  include Mongoid::Timestamps
  include BantikBlog::Base

  # Attributes =====================================================================================
  field :title
  field :slug
  field :description
  field :default_author
  field :posts_per_page, :type => Integer
  field :rss_enabled, :type => Boolean
  field :has_topics, :type => Boolean, :default => false
  field :use_nested_paths, :type => Boolean, :default => true

  # Indices ========================================================================================

  # Constants ======================================================================================

  # Scopes =========================================================================================
  scope :by_slug, lambda {|slug| {:where => {:slug => "#{slug}".gsub('//','/')} } }

  # Relationships ==================================================================================
  references_many :posts
  references_many :topics

  # Behavior =======================================================================================

  attr_accessor :desired_slug
  has_slug :desired_slug

  # Callbacks ======================================================================================

  # Validations ====================================================================================

  validates_presence_of :title, :description, :desired_slug

  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def comments
    Comment.any_in(:post_id => self.posts.map{|p| p.id})
  end

  def feed_address
    "/#{self.slug}/feed.rss".gsub(/\/\//,'/').gsub(/\/\//,'/')
  end

  def has_subtopics?
    ! self.topics.subtopics.blank?
  end

  def humanize_path
    "/#{self.slug}/".gsub(/\/\//,'/').gsub(/\/\//,'/')
  end

  def posts_by_month
    dates = {}
    self.posts.published.each do |p|
      date = p.publication_date.to_s(:year_month)
      dates[date] ||= {}
      dates[date][:full_date] ||= p.publication_date.to_s(:month_year)
      dates[date][:posts] ||= []
      dates[date][:posts] << p
    end
    dates
  end

  def search(keyword)
    self.posts.published.where(:content => /#{keyword}/i)
  end

end
