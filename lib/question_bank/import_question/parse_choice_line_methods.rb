module QuestionBank
  class ImportQuestion
    module ParseChoiceLineMethods

      def _validate_choice_answer_indexs
        choice_answer_indexs = _row_data(:choice_answer_indexs)

        choice_answer_indexs = "" if choice_answer_indexs.blank?

        choice_answer_indexs = choice_answer_indexs.upcase.split("").uniq

        upcase_letters = ("A".."Z").to_a
        if [] != choice_answer_indexs - upcase_letters
          _add_error_info :choice_answer_indexs, "选项答案 中有非法字符"
          return
        end

        choice_answer_indexs = choice_answer_indexs.map do |letter|
          upcase_letters.index(letter)
        end.sort

        @info[:choice_answer_indexs] = choice_answer_indexs
      end


      def _validate_choices
        choices = _row_data(:choices).split(/\r?\n/)

        letter_indexs   = []
        choice_contents = []

        regx = /^([A-Z]{1})\s{1}(.*)/
        choices.each do |str|
          res = str.match(regx)
          if res.blank?
            _add_error_info :choices, "选项 格式不对"
            return
          end
          letter_indexs   << res[1]
          choice_contents << res[2]
        end

        if letter_indexs.count == 0 || letter_indexs != ("A".."Z").first(letter_indexs.count)
          _add_error_info :choices, "选项 格式不对"
          return
        end

        choice_contents.each do |choice|
          if choice.blank?
            _add_error_info :choices, "选项 内容不能为空"
            return
          end
        end

        @info[:choices] = choice_contents
      end

    end
  end
end
