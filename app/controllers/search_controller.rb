# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    authorize! :read, Search
    return @search = Search.new(results: []) if search_params.empty?

    @search = Search.new(search_params)
    @search.results = SearchService.new(@search).call
  end

  private

  def search_params
    return {} unless params[:search]

    params.require(:search).permit(:query, :scope)
  end
end
