module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def index
      if current_user == nil
        @question_record = []
      else 
        @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
      end
    end

    def show
      @question_record = _show(params[:kind],params[:id],params[:second])
      form_html = render_to_string :partial => 'record_index_tr',locals: { question_record: @question_record } 
      render :json => {
        :status => 200,
        :body => form_html
        }
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
      def _show(kind,record_result,second)
        temp = []
        # 根据做题结果查询记录
        if kind == "is_correct"
          @result = is_boolean(record_result)
          @question_record = QuestionBank::QuestionRecord.where(is_correct: @result,user_id: current_user.id).to_a
          return @question_record
        end

        # 查询类型为单选题的记录
        if kind == "single_choice"
          @question_single =  QuestionBank::Question.where(kind: kind).to_a
          record_single = @question_single.map do |single|
            if single.questionrecords != []
              single.questionrecords
            end
          end
          question_single_in_record = record_single.flatten.compact
          if question_single_in_record != []
            question_single_in_record.each do |siglchois|
              if siglchois.user_id == current_user.id
                temp.push(siglchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询类型为多选题的记录
        if kind == "multi_choice"
          @question_multi = QuestionBank::Question.where(kind: kind).to_a
          record_multi = @question_multi.map do |multi|
            if multi.questionrecords != []
              multi.questionrecords
            end
          end
          question_multi_in_record = record_multi.flatten.compact
          if question_multi_in_record != []  
            question_multi_in_record.each do |mutchois|
              if mutchois.user_id == current_user.id
                temp.push(mutchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询类型为填空题的记录
        if kind == "fill"
          @question_fill = QuestionBank::Question.where(kind: kind).to_a
          record_fill = @question_fill.map do |fill|
            if fill.questionrecords != []
              fill.questionrecords
            end
          end
          question_fill_in_record = record_fill.flatten.compact
          if question_fill_in_record != []
            question_fill_in_record.each do |filchois|
              if filchois.user_id == current_user.id
                temp.push(filchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询类型为连线题的记录
        if kind == "mapping"
          @question_mapping = QuestionBank::Question.where(kind: kind).to_a
          record_mapping = @question_mapping.map do |mapping|
            if mapping.questionrecords != []
              mapping.questionrecords              
            end
          end
          question_mapping_in_record = record_mapping.flatten.compact
          if question_mapping_in_record != []
            question_mapping_in_record.each do |mapnchois|
              if mapnchois.user_id == current_user.id
                temp.push(mapnchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询类型为判断题的记录
        if kind == "bool"
          @question_bool = QuestionBank::Question.where(kind: kind).to_a
          record_bool = @question_bool.map do |bool|
            if bool.questionrecords != []
              bool.questionrecords
            end
          end
          question_bool_in_record = record_bool.flatten.compact
          if question_bool_in_record != []
            question_bool_in_record.each do |buchois|
              if buchois.user_id == current_user.id
                temp.push(buchois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询类型为论述题的记录
        if kind == "essay"
          @question_essay = QuestionBank::Question.where(kind: kind).to_a
          record_essay = @question_essay.map do |essay|
            if essay.questionrecords != []
              essay.questionrecords
            end
          end
          question_essay_in_record = record_essay.flatten.compact
          if question_essay_in_record != []
            question_essay_in_record.each do |esaychois|
              if esaychois.user_id == current_user.id
                temp.push(esaychois)
              end
            end
            return temp
          else
            return temp
          end
        end

        # 查询时间在一周内的记录
        if kind == "a_week"
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          @question_record.each do |week|
            if week.created_at >= (Time.now - (7*24*60*60))
              temp.push(week)
            end
          end
          return temp
        end

        # 查询时间在一个月内的记录
        if kind == "a_month"
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          @question_record.each do |month|
            if month.created_at >= (Time.now - (30*24*60*60))
              temp.push(month)
            end
          end
          return temp
        end

        # 查询时间在三个月内的记录
        if kind == "three_months"
          @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
          @question_record.each do |thremons|
            if thremons.created_at >= (Time.now - (3*30*24*60*60))
              temp.push(thremons)
            end
          end
          return temp
        end

        # 查询时间在某一个时间段内的记录
        if kind == "time_fragment"
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

      def is_boolean(record_result)
        return true if record_result == "true"
        return false if record_result == "false"
      end
  end
end