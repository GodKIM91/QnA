class SearchesController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  def index
    query = params[:query]
    model = params[:model]

    if query.empty?
      redirect_to root_path, notice: 'Nothing to search'
    else
      @results = SearchService.new.search(query, model)
      render :results
    end
  end
end