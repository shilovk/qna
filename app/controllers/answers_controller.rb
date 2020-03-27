# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :question, only: %i[new create]
  expose :answers, -> { question.answers }
  expose :answer

  def create
    answer = @question.answers.new(answer_params)
    answer.user = current_user

    if answer.save
      redirect_to question_path(@question), notice: 'Your answer succesfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'Your answer was succesfully deleted.'
    else
      redirect_to question, alert: 'You are not the author of this question.'
    end
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
