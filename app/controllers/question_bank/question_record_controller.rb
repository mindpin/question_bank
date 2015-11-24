module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def index
      if current_user == nil
        @question_record = []
      else 
        if params[:result] == nil && params[:kind] ==nil && params[:time] == nil
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
        else
          @question_record = _show(params[:result],params[:kind],params[:time])
        end
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

    private
      def _show(result,kind,time)
        temp = []
        # 根据做题结果查询记录
        if params[:result] != nil && params[:kind] ==nil && params[:time] == nil
          if result == "true"
            @question_record = QuestionBank::QuestionRecord.where(is_correct: result,user_id: current_user.id).to_a
            return @question_record
          end
          if result == "false"
            @question_record = QuestionBank::QuestionRecord.where(is_correct: result,user_id: current_user.id).to_a
            return @question_record
          end
        end
        # 根据类型查询
        if params[:result] == nil && params[:kind] !=nil && params[:time] == nil
          # 查询类型为单选题的记录
          if kind == "single_choice"
            @question_single = _question_kind_search(kind)
            return @question_single
          end
          # 查询类型为多选题的记录
          if kind == "multi_choice"
            @question_multi = _question_kind_search(kind)
            return @question_multi
          end
          # 查询类型为填空题的记录
          if kind == "fill"
            @question_fill = _question_kind_search(kind)
            return @question_fill
          end
          # 查询类型为连线题的记录
          if kind == "mapping"
            @question_mapping = _question_kind_search(kind)
            return @question_mapping
          end
          # 查询类型为判断题的记录
          if kind == "bool"
            @question_bool = _question_kind_search(kind)
            return @question_bool
          end
          # 查询类型为论述题的记录
          if kind == "essay"
            @question_essay = _question_kind_search(kind)
            return @question_essay
          end
        end
        # 根据时间查询
        if params[:result] == nil && params[:kind] ==nil && params[:time] != nil
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          # 查询时间在一周内的记录
          if time == "a_week"
            @question_a_week = _question_time_search(7,@question_record)
            return @question_a_week
          end
          # 查询时间在一个月内的记录
          if time == "a_month"
            @question_a_month = _question_time_search(30,@question_record)
            return @question_a_month
          end
          # 查询时间在三个月内的记录
          if time == "three_months"
            @question_three_months = _question_time_search(90,@question_record)
            return @question_three_months
          end
          # 查询时间在某一个时间段内的记录
          if time == "time_fragment"
            temp = []
            @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
            @question_record.each do |fragment|
              search_time = fragment.created_at.strftime("%Y-%m-%d")
              if search_time >= record_result &&  search_time <= second
                temp.push(fragment)
              end
            end
            return temp
          end
        end
      end

      def _question_kind_search(kind)
        temp = []
        @question_kind =  QuestionBank::Question.where(kind: kind).to_a
        record_kind = @question_kind.map do |each_kind|
          if each_kind.questionrecords != []
            each_kind.questionrecords
          end
        end
        question_kind_in_record = record_kind.flatten.compact
        if question_kind_in_record != []
          question_kind_in_record.each do |eqikandchois|
            if eqikandchois.user_id == current_user.id
              temp.push(eqikandchois)
            end
          end
          return temp
        else
          return temp
        end
      end

      def _question_time_search(number, question_record)
        temp = []
        question_record.each do |a_time|
          if a_time.created_at >= (Time.now - (number*24*60*60))
            temp.push(a_time)
          end
        end
        return temp
      end
  end
end