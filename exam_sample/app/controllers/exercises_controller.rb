class ExercisesController < ApplicationController

  def index
    if DemoQuestion.subjects.include?(params[:subject])
      @page_name = "exercise_#{params[:subject]}"
      render "mockup/page"
    else
      redirect_to root_path
    end
  end

end

