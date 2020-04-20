# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show]

  authorize_resource

  def index
    authorize! :index, Question
    @questions = Question.all
    render json: @questions
  end

  def show
    authorize! :index, @question
    render json: @question
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params['id'])
  end
end
