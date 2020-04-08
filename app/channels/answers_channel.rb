# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_for question
  end

  private

  def question
    Question.find(params[:question_id])
  end

end
