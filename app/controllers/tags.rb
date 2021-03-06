class Tags < Application

  #will show all the tweets, groups or polls under the tag passed to it
  def show(id)
    tag = Tag.get id
    raise NotFound unless tag
    @result = {:tweets => [], :group => [], :polls => []}
    @result [:tweets] = Tweet.all('taggings.tag_id' => id)
    @result [:groups] = Group.all('taggings.tag_id' => id)
    @result [:polls] = Poll.all('taggings.tag_id' => id)
    render @result
  end

  #no 'create' as a tag is always created in the context of a tweet. See the 'update' in the tweets controller.
  
end
