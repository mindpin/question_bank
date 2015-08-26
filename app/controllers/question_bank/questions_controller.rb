module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    def new_single_choice
      @question = Question.new
    end

    def new_multi_choice
      @question = Question.new
    end

    def new_bool
      @question = Question.new
    end

    def new_mapping
      @question = Question.new
    end

    def new_essay
      @question = Question.new
    end

    def new_fill
      @question = Question.new
    end

    def create
      kind = params[:question][:kind]
      hash = send("question_#{kind}_params")
      @question = Question.new(hash)
      if @question.save
        redirect_to questions_path
      else
        render "new_#{kind}"
      end
    end

    private
      def question_bool_params
        params.require(:question).permit(:kind, :content, :bool_answer, :analysis, :level, :enabled)
      end

      def question_single_choice_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
      end

      def question_multi_choice_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
      end

      def question_fill_params
        params.require(:question).permit(:kind, :content, :fill_answer, :analysis, :level, :enabled)
      end

      def question_mapping_params
        new_mapping_answer = []
        params[:question][:mapping_answer].each { |key,value| new_mapping_answer[key.to_i] = value}
        hash = params.require(:question).permit(:kind, :content, :analysis, :level, :enabled)
        hash[:mapping_answer] = new_mapping_answer
        hash
      end

      def question_essay_params
        params.require(:question).permit(:kind, :content, :analysis, :essay_answer, :level, :enabled)
      end
  end
end
