# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy
  end
end
