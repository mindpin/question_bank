module QuestionBank
  class ImportQuestion
    class ParseLine
      include ParseLineMethods

      def initialize(line_data, index)
        @line_data  = line_data
        @index      = index
        @error_info = {}
        @info       = {}
      end

      def valid?
        @valid ||= _validate_line
      end

      private

      def _validate_line
        case @line_data[0]
        when "单选题"
          _validate_kind_line(ParseSingleChoiceLine)
        when "多选题"
          _validate_kind_line(ParseMultiChoiceLine)
        when "判断题"
          _validate_kind_line(ParseBoolLine)
        when "填空题"
          _validate_kind_line(ParseFillLine)
        when "连线题"
          _validate_kind_line(ParseMappingLine)
        when "论述题"
          _validate_kind_line(ParseEssayLine)
        else
          _add_kind_error
        end
        @error_info.blank?
      end

      def _validate_kind_line(parse_kind_line_class)
        pl = parse_kind_line_class.new(@line_data, @index)
        if pl.valid?
          @info = pl.info
          return
        end

        @error_info = pl.error_info
      end

      def _add_kind_error
        key   = "#{line} 行 #{_row(0)} 列"
        value = "没有 #{@line_data[0]} 这个题目类型"
        @error_info[key] = value
      end

    end
  end
end
