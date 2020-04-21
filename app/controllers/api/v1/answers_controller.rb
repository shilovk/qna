# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params['question_id'])
  end
end
