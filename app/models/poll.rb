class Poll
  include DataMapper::Resource
  
  property :id, Serial
  property :topic, String, :nullable => false
  property :description, Text
  property :published, Boolean
  property :closing_date, Date, :set => ((Date.today + 1)..1.0/0) 
  property :editable, Boolean

  has n, :poll_choices
  has n, :comments
  belongs_to :user

  has_tags #comes from the dm-tags plugin

  def editable_by?(user)
    editable or self.user == user
  end

  def status
    if published
      if closing_date < Date.today
        :closed
      else
        :open
      end
    else
      :unpublished
    end
  end

end
