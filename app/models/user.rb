# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github]

  has_many :questions
  has_many :answers
  has_many :awards, dependent: :destroy
  has_many :votes

  def self.find_for_oauth(data)

  end

  def author?(record)
    id == record&.user_id
  end
end
