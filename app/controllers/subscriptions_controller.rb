# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    current_user.subscribe!(@question)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
  end
end
