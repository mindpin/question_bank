module QuestionBank
  class QuestionRecordController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def index
      @question_record = QuestionBank::QuestionRecord.where(user_id: current_user.id).to_a
    end

    def show
      @question_record = _show(params[:kind],params[:id])
      form_html = render_to_string :partial => 'record_index_tr',locals: { question_record: @question_record } 
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
        temp = []
        if kind == "is_correct"
          @result = is_boolean(record_result)
          @question_record = QuestionBank::QuestionRecord.where(is_correct: @result,user_id: current_user.id).to_a
          return @question_record
        end

        if kind == "single_choice"
          @question_single =  QuestionBank::Question.where(kind: kind).to_a
          record_single = @question_single.map do |single|
            if single.questionrecords != []
              single.questionrecords
            end
          end
          question_single_in_record = record_single.flatten.compact
          question_single_in_record.each do |siglchois|
            if siglchois.user_id == current_user.id
              temp.push(siglchois)
            end
          end
          return temp
        end

        if kind == "multi_choice"
          @question_multi = QuestionBank::Question.where(kind: kind).to_a
          record_multi = @question_multi.map do |multi|
            if multi.questionrecords != []
              multi.questionrecords
            end
          end
          question_multi_in_record = record_multi.flatten.compact
          question_multi_in_record.each do |mutchois|
            if mutchois.user_id == current_user.id
              temp.push(mutchois)
            end
          end
          return temp
        end

        if kind == "fill"
          @question_fill = QuestionBank::Question.where(kind: kind).to_a
          record_fill = @question_fill.map do |fill|
            if fill.questionrecords != []
              fill.questionrecords
            end
          end
          question_fill_in_record = record_fill.flatten.compact
          question_fill_in_record.each do |filchois|
            if filchois.user_id == current_user.id
              temp.push(filchois)
            end
          end
          return temp
        end

        if kind == "mapping"
          @question_mapping = QuestionBank::Question.where(kind: kind).to_a
          record_mapping = @question_mapping.map do |mapping|
            if mapping.questionrecords != []
              mapping.questionrecords              
            end
          end
          question_mapping_in_record = record_mapping.flatten.compact
          question_mapping_in_record.each do |mapnchois|
            if mapnchois.user_id == current_user.id
              temp.push(mapnchois)
            end
          end
          return temp
        end

        if kind == "bool"
          @question_bool = QuestionBank::Question.where(kind: kind).to_a
          record_bool = @question_bool.map do |bool|
            if bool.questionrecords != []
              bool.questionrecords
            end
          end
          question_bool_in_record = record_bool.flatten.compact
          question_bool_in_record.each do |buchois|
            if buchois.user_id == current_user.id
              temp.push(buchois)
            end
          end
          return temp
        end

        if kind == "essay"
          @question_essay = QuestionBank::Question.where(kind: kind).to_a
          record_essay = @question_essay.map do |essay|
            if essay.questionrecords != []
              essay.questionrecords
            end
          end
          question_essay_in_record = record_essay.flatten.compact
          question_essay_in_record.each do |esaychois|
            if esaychois.user_id == current_user.id
              temp.push(esaychois)
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