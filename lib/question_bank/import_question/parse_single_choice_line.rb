module QuestionBank
  class ImportQuestion
    class ParseSingleChoiceLine < ParseLine
      include ParseChoiceLineMethods

      def initialize(line_data, index)
        super
        @info       = {:kind => "single_choice"}
      end

      def _validate_custom_line
        _validate_choices
        _validate_single_choice_answer_indexs
      end

      def _validate_single_choice_answer_indexs
        _validate_choice_answer_indexs
        if @info[:choice_answer_indexs].count != 1
          _add_error_info :choice_answer_indexs, "选项答案只能有一个"
          return
        end
      end


    end
  end
end
