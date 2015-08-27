module QuestionBank
  class ImportQuestion
    class ParseEssayLine < ParseLine

      def initialize(line_data, index)
        super
        @info = {:kind => "essay"}
      end

      def _validate_custom_line
        _validate_essay_answer
      end

      def _validate_essay_answer
        essay_answer = _row_data(:essay_answer)

        @info[:essay_answer] = essay_answer
      end

    end
  end
end
