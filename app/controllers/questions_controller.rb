# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question

  def create
    question.user = current_user

    if question.save
      redirect_to question_path(question), notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    return unless current_user&.author?(question)
    
    question.update(question_params)
    @hide_answers = true
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question was succesfully deleted.'
    else
      redirect_to question, alert: 'You are not the author of this question.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
