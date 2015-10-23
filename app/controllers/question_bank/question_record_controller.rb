module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    def index
      @question_record = QuestionBank::QuestionRecord.all
    end

    def new
      @question_record = QuestionBank::QuestionRecord.new
    end

    def create
      @question        = QuestionBank::Question.find(params[:question_id])
      kind_answer      = send("#{@question.kind}_answer")
      @question_answer = @question.kind_answer
      @answer          = params[:question_record][:kind_answer]
      if @question_answer is @answer 
        :is_correct => true
      else
        :is_correct => false
      @question_record = QuestionBank::QuestionRecord.create(question_record_params(is_correct))
      if @question_record.save
        
      else

      end
    end

    def destroy
      @question_record = QuestionBank::QuestionRecord.find(params[:id])
      @question_record.destroy
    end
    private
      def question_record_params(is_correct)
        params.require(:question_record).permit(:is_correct, :bool_answer, :choice_answer, :essay_answer, :fill_answer, :mapping_answer, :question_id, :user_id)
      end
  end
end