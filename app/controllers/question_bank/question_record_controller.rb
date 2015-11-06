module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    def index
      @question_record = QuestionBank::QuestionRecord.all
    end
  end
end