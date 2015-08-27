module QuestionBank
  class ImportQuestion
    class ParseMappingLine < ParseLine

      def initialize(line_data, index)
        super
        @info = {:kind => "mapping"}
      end

      def _validate_custom_line
        _validate_mapping_answer
      end

      def _validate_mapping_answer
        mapping_answer = _row_data(:mapping_answer)

        mapping_answer = mapping_answer.split(/\r?\n/).map do |str|
          str.split("|")
        end

        @info[:mapping_answer] = mapping_answer
      end

    end
  end
end
