# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: :create
  before_action :load_answer, only: %i[update destroy best up down]

  def create
    @answer = question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    return unless current_user&.author?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    message = if current_user&.author?(@answer)
                @answer.destroy
                { notice: 'Your answer was succesfully deleted.' }
              else
                { alert: 'You are not the author of this question.' }
    end
  end

  def best
    @question = @answer.question

    return unless current_user&.author?(@question)

    @answer.set_best
  end

  def up
    @answer.vote_up unless current_user.author?(@answer)

    render json: { id: @answer, score: @answer.score }
  end

  def down
    @answer.vote_down unless current_user.author?(@answer)

    render json: { id: @answer, score: @answer.score }
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :question

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
