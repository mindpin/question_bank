module QuestionBank
  class TestPaperResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, :class_name => QuestionBank.user_class
    belongs_to :test_paper, :class_name => "QuestionBank::TestPaper"
    has_and_belongs_to_many :question_records, class_name:'QuestionBank::QuestionRecord'
    accepts_nested_attributes_for :question_records, allow_destroy: true

    def make_test_paper_results_msg(id,result,answer)
      @results_msg["#{id}"] = [:is_correct => result,:answer => answer]
    end

    def get_test_paper_results_msg 
      return @results_msg
    end

    def question_records_attributes=(str)
      @results_msg = {}
      question_record_list =str.map do |key,value|
        value
      end
      question_record_list.each do |record_params|
        question = Question.find(record_params[:question_id])
        question_record = question.question_records.create(
          :user          => User.find(record_params[:user_id]),
          :answer        => record_params[:answer]
        )
        make_test_paper_results_msg(record_params[:question_id],question_record.is_correct,question_record.correct_answer)
      end
    end
  end
end