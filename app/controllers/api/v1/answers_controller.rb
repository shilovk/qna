# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, except: %i[index create]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @answer
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: { errors: @answer }, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy
      render json: @answer, status: :ok
    else
      render json: @answer, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def load_question
    @question = Question.with_attached_files.find(params['question_id'])
  end

  def load_answer
    @answer = Answer.find(params['id'])
  end
end
