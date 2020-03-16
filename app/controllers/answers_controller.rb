class AnswersController < ApplicationController
  before_action :question, only: %i[new create]
  expose :answers, -> { question.answers }

  def create
    @answer = answers.new(answer_params)
    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
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
