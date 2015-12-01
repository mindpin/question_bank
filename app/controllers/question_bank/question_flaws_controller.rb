module QuestionBank
  class QuestionFlawsController < QuestionBank::ApplicationController
    before_action :authorization_user
    def index
      @question_flaws = current_user.question_flaws
      if params[:kind] !=nil
        @question_flaws = _kind_search_flaw(params[:kind])
      end

      if params[:time] != nil
        number = 0
        number = 6 if params[:time] == "a_week"
        number = 30 if params[:time] == "a_month"
        number = 90 if params[:time] == "three_months"
        @question_flaws = _time_search_flaw( number, @question_flaws)
      end
    end

    def create
      whether_batch_add = params[:whether_batch]
      if whether_batch_add != "batch_operation"
        question_record = QuestionBank::QuestionRecord.find(params[:question_records_id])
        @question_id = question_record.question_id
        @user_id = question_record.user_id
        @question_flaw = QuestionBank::QuestionFlaw.new(question_id: @question_id, user_id: @user_id)
        if @question_flaw.save
          redirect_to "/question_records"
        else
          render "index"
        end
      end
      if whether_batch_add == "batch_operation"
        record_ids = params[:question_records_id]
        record_ids.each do |recordid|
          if recordid != "on"
            question_record = QuestionBank::QuestionRecord.find(recordid)
            if question_record.is_correct == false
              @question_id = question_record.questions_id
              @user_id = question_record.user_id
              @search_flaw = QuestionBank::QuestionFlaw.where(question_id:@question_id).to_a
              if @search_flaw.length == 0
                @question_flaw = QuestionBank::QuestionFlaw.new(question_id: @question_id, user_id: @user_id)
                @question_flaw.save
              end
            end
          end 
        end
        redirect_to "/question_records", notice: "insert success"
      end
    end

    def destroy
      checked_flaw_ids = params[:checked_ids]
      if checked_flaw_ids == nil
        @question_flaw_single = QuestionBank::QuestionFlaw.find(params[:id])
        @question_flaw_single.destroy
        if current_user == nil
          @question_flaw = []
        else 
          @question_flaw = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaw: @question_flaw}
          render json: {
            status: 200,
            body: form_html
          }
        end
      else
        checked_flaw_ids.each do |flawid|
          if flawid != "on"
            @question_flaw_single = QuestionBank::QuestionFlaw.find(flawid)
            @question_flaw_single.destroy
          end
        end
        if current_user == nil
          @question_flaw = []
        else 
          @question_flaw = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaw: @question_flaw}
          render json: {
            status: 200,
            body: form_html
          }
        end
      end
    end

    private
      def question_flaw_params
        params.require(:question_flaw).permit(:question_id, :user_id )
      end
      
      def _kind_search_flaw(kind)
        @temp = []
        @questions = QuestionBank::Question.where(kind: kind).to_a
        flaw_kind_data = @questions.map do |kind_data|
          if kind_data.question_flaws != []
            kind_data.question_flaws
          end
        end
        question_kind_flaw = flaw_kind_data.flatten.compact
        if question_kind_flaw != []
          question_kind_flaw.each do |value|
            if value.user_id == current_user.id
              @temp.push(value)
            end
          end
          return @temp
        else
          return @temp
        end  
      end

      def _time_search_flaw(number, question)
        temp = []
        question.each do |a_time|
          if a_time.created_at >= (Time.now - (number*24*60*60))
            temp.push(a_time)
          end
        end
        return temp
      end
  end
end