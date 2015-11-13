module QuestionBank
  class QuestionFlawController < QuestionBank::ApplicationController
    def index
      user_id = current_user.id
      @question_flaw = QuestionBank::QuestionFlaw.where(user_id: user_id).to_a
    end

    def create
      question_record = QuestionBank::QuestionRecord.find(params[:question_record_id])
      @question_id = question_record.questions_id
      @user_id = question_record.user_id
      @question_flaw = QuestionBank::QuestionFlaw.new(question_id: @question_id, user_id: @user_id)
      if @question_flaw.save
        redirect_to "/question_record", notice: "insert success"
      else
        render "index"
      end
    end

    def show
      
    end

    def destroy
      @question_flaw_single = QuestionBank::QuestionFlaw.find(params[:id])
      @question_flaw_single.destroy
    end

    private
      def question_flaw_params
        params.require(:question_flaw).permit(:question_id, :user_id )
      end
  end
end