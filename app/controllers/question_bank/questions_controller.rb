module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    def new_mapping
      @question = Question.new
    end

    def create
     p new_mapping_params
   
    end
  private
    def new_mapping_params
      new_mapping_answer = []
      params[:question][:mapping_answer].each { |key,value| new_mapping_answer[key.to_i] = value}
      hash = params.require(:question).permit(:kind, :content, :analysis, :level, :enabled)
      hash[:mapping_answer] = new_mapping_answer
      hash
    end
  end
end
