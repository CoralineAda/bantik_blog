class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include BantikBlog::Base

  # Attributes =====================================================================================
  field :name
  field :short_description
  field :slug
  field :description
  field :active, :type => Boolean, :default => true
  field :featured, :type => Boolean
  field :parent_id
  field :position, :type => Integer
  key :name

  # Indices ========================================================================================
  index :slug, :unique => true
  index :parent_id, :unique => false

  # Constants ======================================================================================

  # Scopes =========================================================================================
  scope :active, :where => {:active => true}, :ascending => :position
  scope :children, lambda {|parent_id| { :ascending => :name, :where => {:parent_id => parent_id} } }
  scope :featured, :where => {:featured => true}, :ascending => :position
  scope :roots, :ascending => :position, :where => {:parent_id => nil}
  scope :subtopics, :ascending => :name, :excludes => {:parent_id => nil}

  # Relationships ==================================================================================
  referenced_in :blog, :inverse_of => :topics
  referenced_in :post

  # Behavior =======================================================================================
  attr_accessor :desired_slug
  has_slug :desired_slug

  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :name, :short_description, :description
  validates_uniqueness_of :name, :short_description, :description

  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def children
    self.blog.topics.where(:parent_id => self.id).asc(:name)
  end

  def desired_slug
    self[:desired_slug] || self.name
  end

  # FIXME
  def depth
    return 0 if self.root?
    return 1 + self.parent.depth if self.parent
  end

  def full_name
    return self.name if self.root?
    return "#{self.parent.name}: #{self.name}"
  end

  def has_subtopics?
    ! self.children.empty?
  end

  def last_post_updated_at
    self.posts.published.first.updated_at
  end

  def latest_posts(count=3)
    if self.root?
      self.children.map{|c| c.posts.published}.flatten.sort{|a,b| a.published_at.to_s <=> b.published_at.to_s}.reverse[0..count-1]
    else
      self.posts.published.limit(count)
    end
  end

  def move_to_root
    self.update_attribute(:parent_id, nil)
  end

  def move_to_child_of(parent_id)
    self.update_attribute(:parent_id, parent_id)
  end

  def parent
    self.blog.topics.find(self.parent_id) if self.parent_id
  end

  def parent_id=(arg)
    return if arg.blank?
    self[:parent_id] = arg
  end

  def post_count
    if self.root?
      self.children.map{|c| c.posts.count}.sum
    else
      self.posts.published.count
    end
  end

  def posts
    self.blog.posts.where(:topic_id => self.id)
  end

  def root?
    self.parent_id.nil?
  end

  def siblings
    self.parent.children - [self]
  end

  def subtopic?
    self.parent_id
  end

  def humanize_path
    if self.root? && self.blog.use_nested_paths?
      "#{self.blog.humanize_path}#{self.id}/"
    elsif self.root?
      "/#{self.id}/"
    else
      "#{self.parent.humanize_path}#{self.id}/"
    end
  end

end
