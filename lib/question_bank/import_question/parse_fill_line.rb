module QuestionBank
  class ImportQuestion
    class ParseFillLine < ParseLine

      def initialize(line_data, index)
        super
        @info = {:kind => "fill"}
      end

      def _validate_custom_line
        _validate_fill_answer
      end

      def _validate_fill_answer
        fill_answer = _row_data(:fill_answer)

        fill_answer = fill_answer.split("|")

        @info[:fill_answer] = fill_answer
      end

    end
  end
end
