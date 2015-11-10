module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    def index
      @question_record = QuestionBank::QuestionRecord.all
    end

    def show
      @question_record = _show(params[:kind],params[:id])
      form_html = render_to_string :partial => 'record_index_tr',locals: { record: @question_record } 
      render :json => {
        :status => 200,
        :body => form_html
      }
    end

    def destroy
      @question_record_single = QuestionBank::QuestionRecord.find(params[:id])
      @question_record_single.destroy
    end

    private
      def _show(kind,record_result)
        if kind == "is_correct"
          @result = is_boolean(record_result)
          @question_record = QuestionBank::QuestionRecord.where(is_correct: @result).to_a
        end
      end

      def is_boolean(record_result)
        return true if record_result == "true"
        return false if record_result == "false"
      end
  end
end