module Searcher

  def query_define
    if(params[:q].blank? and !session[:search].blank?)
      query = session[:search]
    else
      query = params[:q]
      session[:search] = params[:q]
    end

    query
  end

  def model_define(current_model)
    if session[:current_model] != current_model
      session[:current_model] = current_model
      session[:search] = nil
    end
    query_define
  end

end
