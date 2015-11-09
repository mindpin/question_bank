module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    def index
      @question_record = QuestionBank::QuestionRecord.all
    end
    def destroy
      @question_record_single = QuestionBank::QuestionRecord.find(params[:id])
      @question_record_single.destroy
    end
  end
end