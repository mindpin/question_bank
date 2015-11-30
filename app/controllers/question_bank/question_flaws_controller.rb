module QuestionBank
  class QuestionFlawsController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def index
      if current_user == nil
        @question_flaw = []
      else
        if params[:kind] ==nil && params[:time] == nil 
          @question_flaw = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
        else
          @question_flaw = _show(params[:kind],params[:time])
        end
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
          redirect_to "/question_record"
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
        redirect_to "/question_record", notice: "insert success"
      end
    end

    def show
      # @question_flaw = _show(params[:id],params[:kind],params[:second])
      # form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaw: @question_flaw}
      # render json: {
      #   status: 200,
      #   body: form_html
      # }
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

      def _show(kind, time)
        # 根据类型查询
        if kind != nil && time == nil
          if kind == "single_choice"
            @question_single_flaw = _kind_search_flaw(kind)
            return @question_single_flaw
          end
          if kind == "multi_choice"
            @question_multi_flaw = _kind_search_flaw(kind)
            return @question_multi_flaw
          end

          if kind == "fill"
            @question_fill_flaw = _kind_search_flaw(kind)
            return @question_fill_flaw
          end

          if kind == "mapping"
            @question_mapping_flaw = _kind_search_flaw(kind)
            return @question_mapping_flaw
          end

          if kind == "bool"
            @question_bool_flaw = _kind_search_flaw(kind)
            return @question_bool_flaw
          end

          if kind == "essay"
            @question_essay_flaw = _kind_search_flaw(kind)
            return @question_essay_flaw
          end
        end
        # 根据时间查询
        if kind == nil && time != nil
          @question = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          if time == "a_week"
            @question_a_week = _time_search_flaw(7, @question)
            return @question_a_week
          end
          if time == "a_month"
            @question_a_month = _time_search_flaw(30, @question)
            return @question_a_month
          end
          if time == "three_months"
            @question_three_months = _time_search_flaw(90, @question)
            return @question_three_months
          end
        end
        # 根据类型和时间查询双条件查询
        if kind != nil && time != nil
          @question_kind = _kind_search_flaw(kind)
          if time == "a_week"
            @question_a_week = _time_search_flaw(7, @question_kind)
            return @question_a_week
          end
          if time == "a_month"
            @question_a_month = _time_search_flaw(30, @question_kind)
            return @question_a_month
          end
          if time == "three_months"
            @question_three_months = _time_search_flaw(90, @question_kind)
            return @question_three_months
          end
        end
      end

      def _kind_search_flaw(kind)
        temp = []
        @question = QuestionBank::Question.where(kind: kind).to_a
        flaw_kind_data = @question.map do |kind_data|
          if kind_data.questionflaws != []
            kind_data.questionflaws
          end
        end
        question_kind_flaw = flaw_kind_data.flatten.compact
        if question_kind_flaw != []
          question_kind_flaw.each do |kindchoice|
            if kindchoice.user_id == current_user.id
              temp.push(kindchoice)
            end
          end
          return temp
        else
          return temp
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