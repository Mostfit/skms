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

  is_indexed :texts => [:topic, :description], :values => [[:topic, 6, 'topic', :string],[:description, 7, 'description', :string]], :terms => [[:topic, 'G', 'poll'], [:description, 'H', 'poll']] #uses dm-xapian plugin for 'full text searching'. Read more at: 'http://github.com/frabcus/acts_as_xapian/tree/master'

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
