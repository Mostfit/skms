class Tags < Application

  def show(id)
    tag = Tag.get id
    raise NotFound unless tag
    @tweets = Tweet.all 'taggings.tag_id' => id
    render @tweets
  end
  
end
