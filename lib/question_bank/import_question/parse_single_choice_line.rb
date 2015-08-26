module QuestionBank
  class ImportQuestion
    class ParseSingleChoiceLine
      include ParseLineMethods

      def initialize(line_data, index)
        p line_data
        @line_data  = line_data
        @index      = index
        @error_info = {}
        @info       = {:kind => "single_choice"}
      end

      def valid?
        @valid ||= _validate_line
      end

      private
      # ["单选题", "1", "巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", "是", "常用的客户分类标准和方法中，按照___划分为：产生的利润较大、产生的利润较小与不产生利润。", "A 行业竞争优势\nB 客户创造价值的大小\nC 关系客户的需求\nD 客户的密切程度", "B"]
      def _validate_line
        _validate_level
        _validate_analysis
        _validate_enabled
        _validate_content
        _validate_choice_answer_indexs
        _validate_choices
        @error_info.blank?
      end

      def _validate_level
        level = @line_data[1]

        if level == nil
          @error_info["#{line} 行 #{_row(1)} 列"] = "难度系数 不能为空"
          return
        end

        if level == "0"
          @error_info["#{line} 行 #{_row(1)} 列"] = "难度系数 不能是0"
          return
        end

        if level.to_i.to_s != level
          @error_info["#{line} 行 #{_row(1)} 列"] = "难度系数 必须是大于0的数字"
          return
        end

        @info[:level] = level.to_i
      end

      def _validate_analysis
        analysis         = @line_data[2]
        @info[:analysis] = analysis
      end

      def _validate_enabled
        enabled         = @line_data[3]

        if enabled == nil
          @error_info["#{line} 行 #{_row(3)} 列"] = "是否启用 内容不能为空"
          return
        end

        enabled = enabled.strip

        if !["是","否"].include?(enabled)
          @error_info["#{line} 行 #{_row(3)} 列"] = "是否启用 必须填写 是 或者 否"
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
        content = @line_data[4]

        if content == nil
          @error_info["#{line} 行 #{_row(4)} 列"] = "题目内容 不能为空"
          return
        end

        enabled = enabled.strip
      end

    end
  end
end
