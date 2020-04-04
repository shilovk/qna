# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update]

  expose :questions, -> { Question.all }
  expose :question

  def new
    @question = Question.new
    @question.links.new # .build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to question_path(@question), notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    return unless current_user&.author?(@question)

    @question.update(question_params)
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

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url])
  end
end
