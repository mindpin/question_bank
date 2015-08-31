module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController 
    include QuestionBank::ApplicationHelper
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

    def index
      params[:page] ||= 1
      @questions = Question.page(params[:page]).per(6)
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

    def edit
      @question = Question.find(params[:id])
      @kind = @question.kind
      render "edit_#{@kind}"
    end

    def update
      @question = Question.find(params[:id])
      @kind = @question.kind
      hash = send("question_#{@kind}_params")
      if @question.update_attributes(hash)
        redirect_to "/questions"
      else
        render "edit_#{@kind}"
      end
    end

    def destroy
      @question = Question.find(params[:id])
      @question.destroy
      redirect_to "/questions"
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
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :fill_answer => [])
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
