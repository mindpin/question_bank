module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    def new_single_choice
      
    end

    def create
    end

    def index
    end

    private
      def question_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
      end
  end
end