# frozen_string_literal: true

class SearchService
  AVAILABLE_RESOURCES = %w[Question Answer Comment User].freeze
  AVAILABLE_SCOPES = ['All', AVAILABLE_RESOURCES].flatten.freeze

  def initialize(search)
    @query = search.query
    @scope = search.scope
  end

  def call
    search_class.search(ThinkingSphinx::Query.escape(@query))
  end

  private

  def search_class
    return ThinkingSphinx if @scope == 'All'

    @scope.constantize
  end
end
