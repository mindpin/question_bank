module QuestionBank
  class ImportQuestion
    class ParseLine
      FIELD_INDEX_MAPPING = {
        :kind                 => 0,
        :level                => 1,
        :analysis             => 2,
        :enabled              => 3,
        :content              => 4,
        :choices              => 5,
        :choice_answer_indexs => 6,
        :mapping_answer       => 6,
        :essay_answer         => 6,
        :fill_answer          => 6,
        :bool_answer          => 6
      }

      attr_reader :info, :error_info
      def initialize(line_data, index)
        @line_data  = line_data
        @index      = index
        @error_info = {}
      end

      def valid?
        @valid ||= _validate_line
      end

      def _validate_line
        _validate_level
        _validate_analysis
        _validate_enabled
        _validate_content
        _validate_custom_line
        _validate_by_question if @error_info.blank?
        @error_info.blank?
      end

      def _validate_custom_line
        raise "#{self.class.name} 未实现 _validate_custom_line"
      end

      def line
        @index + 1
      end

      def _row_index(row_name)
        FIELD_INDEX_MAPPING[row_name.to_sym]
      end

      def _row(row_name)
        ["A","B","C","D","E","F","G"][_row_index(row_name)]
      end

      def _row_data(row_name)
        @line_data[_row_index(row_name)]
      end

      def _validate_level
        level = _row_data(:level)

        if level == nil
          _add_error_info :level, "难度系数 不能为空"
          return
        end

        if level == "0"
          _add_error_info :level, "难度系数 不能是0"
          return
        end

        if level.to_i.to_s != level
          _add_error_info :level, "难度系数 必须是大于0的数字"
          return
        end

        @info[:level] = level.to_i
      end

      def _validate_analysis
        analysis         = _row_data(:analysis)
        @info[:analysis] = analysis
      end


      def _validate_enabled
        enabled         = _row_data(:enabled)

        if enabled == nil
          _add_error_info(:enabled, "是否启用 内容不能为空")
          return
        end

        enabled = enabled.strip

        if !["是","否"].include?(enabled)
          _add_error_info(:enabled, "是否启用 必须填写 是 或者 否")
          return
        end

        if enabled == "是"
          @info[:enabled] = true
        end

        if enabled == "否"
          @info[:enabled] = false
        end

      end

      def _validate_content
        content = _row_data(:content)
        @info[:content] = content
      end

      def _validate_by_question
        q = QuestionBank::Question.new(@info)
        q.valid?
        q.errors.messages.each do |field, error_message|
          _add_error_info(field.to_sym, error_message)
        end
      end

      def _add_error_info(field, message)
        @error_info["#{line} 行 #{_row(field.to_sym)} 列"] ||= []
        if message.is_a?(String)
          @error_info["#{line} 行 #{_row(field.to_sym)} 列"] << message
        end
        if message.is_a?(Array)
          @error_info["#{line} 行 #{_row(field.to_sym)} 列"] += message
        end

      end

      def self.build_by(line_data, index)
        case line_data[0]
        when "单选题"
          ParseSingleChoiceLine.new(line_data, index)
        when "多选题"
          ParseMultiChoiceLine.new(line_data, index)
        when "判断题"
          ParseBoolLine.new(line_data, index)
        when "填空题"
          ParseFillLine.new(line_data, index)
        when "连线题"
          ParseMappingLine.new(line_data, index)
        when "论述题"
          ParseEssayLine.new(line_data, index)
        else
          ParseKindErrorLine.new(line_data, index)
        end
      end

    end
  end
end
