module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    def new_bool
      @question = Question.new
    end

    def create
      case params[:question][:kind]
      when 'bool' then _create_bool
      end
    end

    def _create_bool
      @question = Question.new(question_bool_params)
      if @question.save
        redirect_to "/questions"
      else
        redirect_to "/questions/new_bool"
      end
    end

    private
      def question_bool_params
        params.require(:question).permit(:kind, :content, :bool_answer, :analysis, :level, :enabled)
      end
  end
end
