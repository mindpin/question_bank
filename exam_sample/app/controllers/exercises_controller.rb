class ExercisesController < ApplicationController

  def index
    if DemoQuestion.subjects.include?(params[:subject])
      @page_name = "exercise_#{params[:subject]}"
      @component_data = {
        questions: (1..10).map do |i|
          num = rand(56887746371819585459)
          {
            content: num.to_s,
            answer: num.to_s
          }
        end
      }


      render "mockup/page"
    else
      redirect_to root_path
    end
  end

end

