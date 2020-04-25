# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :up, :down, to: :vote
    @user = user
    return guest_abilities unless user
    return admin_abilities if user.admin?

    user_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, ActiveStorage::Attachment, Link, Award, Subscription]

    can %i[update destroy], [Question, Answer, Comment], user_id: user.id

    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }

    can %i[up down], [Question, Answer]
    cannot %i[up down], [Question, Answer], user_id: user.id

    can :best, Answer, question: { user_id: user.id }

    can %i[update destroy], Link, linkable: { user_id: user.id }

    can %i[update destroy], Award, question: { user_id: user.id }

    can :destroy, Subscription, user_id: user.id
  end
end
