module QuestionBank
  class TestPaperResultsController < QuestionBank::ApplicationController
    def new
      @test_paper = TestPaper.find(params[:test_paper_id])
      @test_paper_result = @test_paper.test_paper_results.new
    end

    def create
      test_paper = TestPaper.find(params[:test_paper_id])
      test_paper_result = test_paper.test_paper_results.new(:question_records_attributes => params[:test_paper_result][:question_records_attributes],:user => current_user)
      if test_paper_result.save
        render :json => {
          :test_paper_results_msg => test_paper_result.get_test_paper_results_msg 
        }
      end
    end

    private
      # def test_paper_result_params
      #   params.require(:test_paper_result).permit(:question_records_attributes => {:question_id=>[],:user_id=>[],:answer=>[]})
      # end
  end
end