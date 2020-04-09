# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true
end
