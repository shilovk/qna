# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :files
  has_many :links, as: :linkable do
    object.links.order(id: :asc)
  end
end
