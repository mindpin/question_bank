module QuestionBank
  class ImportQuestion
    module ParseLineMethods
      
      def line
        @index + 2
      end

      def _row(row_index)
        ["A","B","C","D","E","F","G"][row_index]
      end

    end
  end
end
