module QuestionBank
  class QuestionFlawsController < QuestionBank::ApplicationController
    before_action :authorization_user
    def index
      @question_flaws = current_user.question_flaws
      if params[:kind] !=nil
        @question_flaws = @question_flaws.with_kind(params[:kind])
      end

      if params[:time] != nil
        time_query_hash = {
          "a_week"       => {:start_time => (Date.today - 6).to_time,:end_time => Time.now.to_time},
          "a_month"      => {:start_time => (Date.today - 30).to_time,:end_time => Time.now.to_time },
          "three_months" => {:start_time => (Date.today - 90).to_time,:end_time => Time.now.to_time }
        }
        query_str = time_query_hash[:params[:time]]
        @question_flaws = @question_flaws.with_created_at(query_str)
      end
    end

    def create
      if params[:whether_batch] != "batch_operation"
        question_record = QuestionBank::QuestionRecord.where(question_id: params[:question_id]).first
        @question_flaw = QuestionBank::QuestionFlaw.new(question_id: params[:question_id], user_id: question_record.user_id)
        if @question_flaw.save
          render :json => {:message => "success"}
        else
          render "index"
        end
      end
      if params[:whether_batch] == "batch_operation"
        params[:questions_id].each do |qid|
          if qid != "on"
            question_record = QuestionBank::QuestionRecord.where(question_id: qid).first
            if question_record.is_correct == false
              @search_flaw = QuestionBank::QuestionFlaw.where(question_id: qid).to_a
              if @search_flaw.length == 0
                @question_flaw = QuestionBank::QuestionFlaw.create(question_id: qid, user_id: question_record.user_id)
              end
            end
          end 
        end
        render :json => {:message => "success"}
      end
    end

    def destroy
      checked_flaw_ids = params[:checked_ids]
      if checked_flaw_ids == nil
        @question_flaw_single = QuestionBank::QuestionFlaw.find(params[:id])
        @question_flaw_single.destroy
      else
        checked_flaw_ids.each do |flawid|
          if flawid != "on"
            @question_flaw_single = QuestionBank::QuestionFlaw.find(flawid)
            @question_flaw_single.destroy
          end
        end
      end
      @question_flaws = current_user.question_flaws
      form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaws: @question_flaws}
      render json: {
        status: 200,
        body: form_html
      }
    end

    private
      def question_flaw_params
        params.require(:question_flaw).permit(:question_id, :user_id )
      end
  end
end