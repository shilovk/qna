# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  has_many :files
  has_many :links, as: :linkable do
    object.links.order(id: :asc)
  end

  def short_title
    object.title.truncate(7)
  end
end
