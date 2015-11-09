module QuestionBank
  class QuestionFlawController < QuestionBank::ApplicationController
    def index
      @question_flaw = QuestionBank::QuestionFlaw.all
    end

    def create
      
    end

    def destroy
      @question_flaw_single = QuestionBank::QuestionFlaw.find(params[:id])
      @question_flaw_single.destroy
    end

    private
      def question_flaw_params
        
      end
  end
end