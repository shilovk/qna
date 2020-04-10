# frozen_string_literal: true

module BroadcastQuestion
  extend ActiveSupport::Concern

  def subscribed
    stream_for question
  end

  private

  def question
    Question.find(params[:question_id])
  end
end
