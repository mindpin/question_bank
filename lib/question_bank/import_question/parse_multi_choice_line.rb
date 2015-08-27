module QuestionBank
  class ImportQuestion
    class ParseMultiChoiceLine < ParseLine
      include ParseChoiceLineMethods

      def initialize(line_data, index)
        super
        @info       = {:kind => "multi_choice"}
      end

      def _validate_custom_line
        _validate_choices
        _validate_multi_choice_answer_indexs
      end

      def _validate_multi_choice_answer_indexs
        _validate_choice_answer_indexs
        if @info[:choice_answer_indexs].count < 2
          _add_error_info :choice_answer_indexs, "选项答案最少有两个"
          return
        end
      end


    end
  end
end
