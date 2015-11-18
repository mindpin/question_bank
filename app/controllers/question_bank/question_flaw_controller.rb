module QuestionBank
  class QuestionFlawController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def index
      if current_user == nil
        @question_flaw = []
      else 
        @question_flaw = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
      end
    end

    def create
      whether_batch_add = params[:whether_batch]
      if whether_batch_add == nil
        question_record = QuestionBank::QuestionRecord.find(params[:question_record_id])
        @question_id = question_record.questions_id
        @user_id = question_record.user_id
        @question_flaw = QuestionBank::QuestionFlaw.new(question_id: @question_id, user_id: @user_id)
        if @question_flaw.save
          redirect_to "/question_record", notice: "insert success"
        else
          render "index"
        end
      else
        record_ids = params[:question_record_id]
        record_ids.each do |recordid|
          if recordid != "on"
            question_record = QuestionBank::QuestionRecord.find(recordid)
            @question_id = question_record.questions_id
            @user_id = question_record.user_id
            @search_flaw = QuestionBank::QuestionFlaw.where(question_id:@question_id).to_a
            if @search_flaw.length == 0
              @question_flaw = QuestionBank::QuestionFlaw.new(question_id: @question_id, user_id: @user_id)
              @question_flaw.save
            end
          end 
        end
        redirect_to "/question_record", notice: "insert success"
      end
    end

    def show
      @question_flaw = _show(params[:id],params[:kind],params[:second])
      form_html = render_to_string partial: "flaw_index_tr", locals: {question_flaw: @question_flaw}
      render json: {
        status: 200,
        body: form_html
      }
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

      def _show(id, kind, second)
        temp = []
        if kind == "single_choice"
          @question = QuestionBank::Question.where(kind: kind).to_a
          flaw_single = @question.map do |single|
            if single.questionflaws != []
              single.questionflaws
            end
          end
          quesiton_single_flaw = flaw_single.flatten.compact
          if quesiton_single_flaw != []
            quesiton_single_flaw.each do |sigchois|
              if sigchois.user_id == current_user.id
                temp.push(sigchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        if kind == "multi_choice" 
          @question = QuestionBank::Question.where(kind: kind).to_a
          flaw_multi = @question.map do |multi|
            if multi.questionflaws != []
              multi.questionflaws
            end
          end
          question_multi_flaw = flaw_multi.flatten.compact
          if question_multi_flaw != []
            question_multi_flaw.each do |mutichois|
              if mutichois.user_id == current_user.id
                temp.push(mutichois)
              end
            end
            return temp
          else
            return temp
          end
        end

        if kind == "fill"
          @quesiton = QuestionBank::Question.where(kind: kind).to_a
          flaw_fill = @quesiton.map do |fill|
            if fill.questionflaws != []
              fill.questionflaws
            end
          end
          question_fill_flaw = flaw_fill.flatten.compact
          if question_fill_flaw != []
            question_fill_flaw.each do |fillchoice|
              if fillchoice.user_id == current_user.id
                temp.push(fillchoice)
              end
            end
            return temp
          else
            return temp
          end
        end

        if kind == "mapping"
          @question = QuestionBank::Question.where(kind: kind).to_a
          flaw_mapping = @question.map do |mapping|
            if mapping.questionflaws != []
              mapping.questionflaws
            end
          end
          question_mapping_flaw = flaw_mapping.flatten.compact
          if question_mapping_flaw != []
            question_mapping_flaw.each do |mapinchois|
              if mapinchois.user_id == current_user.id
                temp.push(mapinchois)
              end
            end
            return temp
          else
            return temp
          end    
        end

        if kind == "bool"
          @question = QuestionBank::Question.where(kind: kind).to_a
          flaw_bool = @question.map do |bool|
            if bool.questionflaws != []
              bool.questionflaws
            end
          end
          question_bool_flaw = flaw_bool.flatten.compact
          if question_bool_flaw != []
            question_bool_flaw.each do |buchoice|
              if buchoice.user_id == current_user.id
                temp.push(buchoice)
              end
            end
            return temp
          else
            return temp
          end  
        end

        if kind == "essay"
          @question = QuestionBank::Question.where(kind: kind).to_a
          flaw_essay = @question.map do |essay|
            if essay.questionflaws != []
              essay.questionflaws
            end
          end
          question_essay_flaw = flaw_essay.flatten.compact
          if question_essay_flaw != []
            question_essay_flaw.each do |esaychoice|
              if esaychoice.user_id == current_user.id
                temp.push(esaychoice)
              end
            end
            return temp
          else
            return temp
          end  
        end

        # 查询时间在一周内的记录
        if kind == "a_week"
          @question = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          @question.each do |week|
            if week.created_at >= (Time.now - (7*24*60*60))
              temp.push(week)
            end
          end
          return temp
        end

        # 查询时间在一个月内的记录
        if kind == "a_month"
          @question = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          @question.each do |amonth|
            if amonth.created_at >= (Time.now - (30*24*60*60))
              temp.push(amonth)
            end
          end
          return temp
        end

        # 查询时间在三个月内的记录
        if kind == "three_month"
          @question = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          @question.each do |three_month|
            if three_month.created_at >= (Time.now - (3*30*24*60*60))
              temp.push(three_month)
            end
          end
          return temp
        end

        # 查询时间在某一个时间段内的记录
        if kind == "time_fragment"
          @question = QuestionBank::QuestionFlaw.where(user_id: current_user.id).to_a
          @question.each do |fragment|
            if fragment.created_at >= id &&  fragment.created_at <= second
              temp.push(fragment)
            end
          end
          return temp
        end

      end
  end
end