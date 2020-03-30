# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: %i[create]

  def create
    @answer = question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def destroy
    answer = Answer.find(params[:id])
    message = if current_user&.author?(answer)
                answer.destroy
                { notice: 'Your answer was succesfully deleted.' }
              else
                { alert: 'You are not the author of this question.' }
    end

    redirect_to question_path(answer.question), message
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
