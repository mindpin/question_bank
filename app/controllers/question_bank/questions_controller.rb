module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    def new
      @question = Question.new
    end

    def create
      @question = Question.new(question_bool_params)
      p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      p @question
      if @question.save

      else

      end
    end

    private
      def question_bool_params
        params.require(:question).permit(:kind, :content, :bool_answer, :analysis, :level, :enabled)
      end
  end
end
