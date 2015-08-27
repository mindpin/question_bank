module QuestionBank
  class ImportQuestion
    class ParseKindErrorLine < ParseLine
      def _validate_line
        _add_error_info :kind, "没有 #{_row_data(:kind)} 这个题目类型"
        @error_info.blank?
      end

    end
  end
end
