# Instead of the standard composition, convert everything
# non-alpha and non-digit to dash and squeeze
class String
  def identify
    if Mongoid.parameterize_keys
      gsub(/\'/,'').gsub(/[^a-zA-Z0-9]+/, ' ').strip.gsub(' ', '-').downcase
    else
      self
    end
  end
end