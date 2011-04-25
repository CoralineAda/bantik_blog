# TODO rakismet integration to auto-detect spam
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rakismet::Model

  # Attributes =====================================================================================
  field :author
  field :author_url
  field :author_email
  field :content
  field :user_ip
  field :user_agent
  field :referrer
  field :is_spam, :type => Boolean, :default => false
  field :state, :default => 'pending'

  # Indices ========================================================================================

  # Constants ======================================================================================
  FILTERS = [
    {:scope => "approved",  :label => "Approved"},
    {:scope => "pending",   :label => "Pending"},
    {:scope => "spam",      :label => "Spam"}
  ]

  # Scopes =========================================================================================
  scope :approved,  :where => {:state => 'approved'}, :ascending => :created_at
  scope :pending,   :where => {:state => 'pending'}, :ascending => :created_at
  scope :spam,      :where => {:is_spam => true}, :ascending => :created_at

  # Relationships ==================================================================================
  belongs_to :post

  # Behavior =======================================================================================

  # Callbacks ======================================================================================
  before_save :classify

  # Validations ====================================================================================
  validates_presence_of :author, :author_email, :content

  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def approve!
    self.update_attribute(:state, 'approved')
  end

  def classify
    self.is_spam = self.spam?
  end

  def pending?
    self.state == 'pending'
  end

  def permalink
    self.post.permalink
  end

  def spammify!
    self.spam!
    self.update_attribute(:is_spam, true)
  end

end
