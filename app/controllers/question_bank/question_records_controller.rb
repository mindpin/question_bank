module QuestionBank
  class QuestionRecordsController < QuestionBank::ApplicationController
    before_action :authorization_user

    def index
      @question_records = current_user.question_records
      if params[:is_correct] != nil
        @question_records = @question_records.where(:is_correct => params[:is_correct])
      end

      if params[:kind] != nil
        @question_records = @question_records.where(:kind => params[:kind])
      end

      if params[:time] != nil
        time_query_hash = {
          "a_week"       => {:created_at.gte => (Date.today - 6).to_time},
          "a_month"      => {:created_at.gte => (Date.today - 30).to_time},
          "three_months" => {:created_at.gte => (Date.today - 90).to_time}
        }
        time_query_hash.default = {}

        @question_records = @question_records.where(time_query_hash[params[:time]])
      end
    end

    def show
      # @question_record = _show(params[:kind],params[:id],params[:second])
      # form_html = render_to_string :partial => 'record_index_tr',locals: { question_record: @question_record }
      # render :json => {
      #   :status => 200,
      #   :body => form_html
      #   }
    end

    def destroy
      checked_ids = params[:checked_ids]
      if checked_ids == nil
        @question_record_single = QuestionBank::QuestionRecord.find(params[:id])
        @question_record_single.destroy
        if current_user == nil
          @question_record = []
        else
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          form_html = render_to_string :partial => 'record_index_tr',locals: { question_record: @question_record }
          render :json => {
            :status => 200,
            :body => form_html
            }
        end
      else
        checked_ids.each do |recordid|
          if recordid != "on"
            @question_record_single = QuestionBank::QuestionRecord.find(recordid)
            @question_record_single.destroy
          end
        end
        if current_user == nil
          @question_record = []
        else
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          form_html = render_to_string :partial => 'record_index_tr',locals: { question_record: @question_record }
          render :json => {
            :status => 200,
            :body => form_html
            }
        end
      end
    end

  end
end
