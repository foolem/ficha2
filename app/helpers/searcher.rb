module Searcher

  def query_define()
    search = controller_name.("_search")
    puts search
    if(params[:q].blank? and !session[:course_search].blank?)
      @query = session[:course_search]
    else
      @query = params[:q]
      session[:course_search] = params[:q]
    end
  end

end
