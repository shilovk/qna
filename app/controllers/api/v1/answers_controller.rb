# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]
  before_action :set_answer, except: %i[index]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params['question_id'])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end
end
