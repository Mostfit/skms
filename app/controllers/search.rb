class Search < Application

  def search
    @result = []
    if params[:query]
      query = params[:query]
      search = ActsAsXapian::Search.new ['Tweet'], query, :limit => 10
      search.results.each do |value|
        @result << value[:model]
      end
    end
    render
  end
  
end
