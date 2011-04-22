# TODO rakismet integration to auto-detect spam
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  # Attributes =====================================================================================
  field :author
  field :author_url
  field :author_email
  field :content
  field :state, :default => 'pending'

  # Indices ========================================================================================

  # Constants ======================================================================================
  FILTERS = [
    {:scope => "approved",  :label => "Approved"},
    {:scope => "pending",   :label => "Pending"}
  ]

  # Scopes =========================================================================================
  scope :approved, :where => {:state => 'approved'}, :ascending => :created_at
  scope :pending, :where => {:state => 'pending'}, :ascending => :created_at

  # Relationships ==================================================================================
  belongs_to :post

  # Behavior =======================================================================================

  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :author, :author_email, :content

  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def approve!
    self.update_attribute(:state, 'approved')
  end

  def pending?
    self.state == 'pending'
  end

end
