# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @question
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.with_attached_files.find(params['id'])
  end
end
