module QuestionBank
  class ImportQuestion
    class ParseBoolLine < ParseLine

      def initialize(line_data, index)
        super
        @info = {:kind => "bool"}
      end

      def _validate_custom_line
        _validate_bool_answer
      end

      def _validate_bool_answer
        bool_answer = _row_data(:bool_answer)


        if bool_answer == nil
          _add_error_info :bool_answer, "答案 内容不能为空"
          return
        end

        bool_answer = bool_answer.strip

        if !["正确","错误"].include?(bool_answer)
          _add_error_info :bool_answer, "答案 必须填写 正确 或者 错误"
          return
        end

        if bool_answer == "正确"
          @info[:bool_answer] = true
        end

        if bool_answer == "错误"
          @info[:bool_answer] = false
        end

      end

    end
  end
end
