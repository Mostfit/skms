class Search < Application

  def search
    @result = {:tweets => [], :groups => [], :polls => []}
    if params[:query]
      query = params[:query]
      search = ActsAsXapian::Search.new ['Tweet', 'Group', 'Poll'], query, :limit => 10
      search.results.each do |value|
        if value[:model].class == Tweet
          @result[:tweets] << value[:model]
        elsif value[:model].class == Group
          @result[:groups] << value[:model]
        elsif value[:polls].class == Poll
          @result[:polls] << value[:model]
        end
      end
    end
    render
  end
  
end
