class Search < Application

  def index
    render
  end

  def search
    query = params[:search]
  end
  
end
