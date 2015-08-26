module QuestionBank
  class ImportQuestion
    def initialize(csv_file)
      @csv_file       = csv_file
      @question_infos = []
      @error_info     = {}
      _parse_csv_file
    end

    def valid?
      @valid ||= _validate_csv_data
    end

    def import
      @question_infos.each do |info|
        QuestionBank::Question.create!(info)
      end
    end

    private

    def _validate_csv_data
      @csv_data.each_with_index do |line_data, index|
        next if index == 0
        _validate_line(line_data, index)
      end
      @error_info.blank?
    end

    def _validate_line(line_data, index)
      pl = ParseLine.new(line_data, index)

      if pl.valid?
        @question_infos << pl.info
        return
      end

      @error_info.merge! pl.error_info
    end

    def _parse_csv_file
      begin
        @csv_data = CSV.read(@csv_file.path, :encoding => "gbk")
      rescue
        begin
          @csv_data = CSV.read(@csv_file.path, :encoding => "utf-8")
        rescue
          "导入文件的格式错误"
        end
      end
    end


  end
end
