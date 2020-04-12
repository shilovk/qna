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
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], user: user

    can :vote, [Question, Answer] do |resource|
      resource.user != user
    end

    can :best, Answer do |answer|
      answer.question.user == user
    end
  end
end
