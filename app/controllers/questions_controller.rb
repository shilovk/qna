# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy up down]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
  end

  def edit; end

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
    if current_user&.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was succesfully deleted.'
    else
      redirect_to @question, alert: 'You are not the author of this question.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy], award_attributes: %i[title image])
  end
end
