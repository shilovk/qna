# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank

  after_create_commit :subscribe_author!

  validates :title, :body, presence: true

  scope :after_date, ->(date) { where('created_at > ?', date) }

  private

  def subscribe_author!
    user.subscribe!(self)
  end
end
