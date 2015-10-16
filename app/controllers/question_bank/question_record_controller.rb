module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    def index
      @question_record = QuestionBank::QuestionRecord.all
    end

    def new
      @question_record = QuestionBank::QuestionRecord.new
    end

    def create
      @question_record = QuestionBank::QuestionRecord.create(question_record_params)
      if @question_record.save

      else

      end
    end

    def destroy
      @question_record = QuestionBank::QuestionRecord.find(params[:id])
      @question_record.destroy
    end
    private
      def question_record_params
        params.require(:question_record).permit(:is_correct, :bool_answer, :choice_answer, :essay_answer, :fill_answer, :mapping_answer, :question_id, :user_id)
      end
  end
end