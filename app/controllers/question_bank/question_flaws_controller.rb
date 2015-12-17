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
      @question_flaw = current_user.question_flaws.new(question_id: params[:question_id])
      if @question_flaw.save
        render :json => {:message => "success"}
      else
        render "index"
      end
    end

    def batch_create
      params[:question_ids].each do |qid|
        question_record = current_user.question_records.where(question_id: qid).first
        next if question_record.is_correct == true
        @search_flaw = current_user.question_flaws.where(question_id: qid).to_a
        next if @search_flaw.length != 0
        @question_flaw = current_user.question_flaws.create(question_id: qid)
      end
      render :json => {:message => "success"}
    end

    def destroy
      @question_flaw_single = current_user.question_flaws.find(params[:id])
      if @question_flaw_single.destroy
        @question_flaws = current_user.question_flaws.to_a - [@question_flaw_single]
        form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaws: @question_flaws}
        render json: {
          status: 200,
          body: form_html,
          message: "success"
        }
      end
    end

    def batch_destroy
      temp = []
      params[:question_flaw_ids].each do |fid|
        @question_flaw_single = current_user.question_flaws.find(fid)
        temp.push(@question_flaw_single)
        @question_flaw_single.destroy
      end
      @question_flaws = current_user.question_flaws.to_a - temp
      form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaws: @question_flaws}
      render json: {
        status: 200,
        body: form_html,
        message: "success"
      }
    end

    private
      def question_flaw_params
        params.require(:question_flaws).permit(:question_id)
      end
  end
end