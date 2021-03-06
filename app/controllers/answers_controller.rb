# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: :show
  before_action :question, only: :create
  before_action :load_answer, only: %i[show update destroy best up down]
  after_action :broadcast_answer, only: :create

  authorize_resource

  def show; end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    message = { notice: 'Your answer was succesfully deleted.' }
  end

  def best
    @question = @answer.question
    @answer.set_best
  end

  private

  def question
    @question = Question.find(params[:question_id])
    gon.question_id = @question.id
  end

  helper_method :question

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def broadcast_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(@answer.question, @answer)
  end
end
