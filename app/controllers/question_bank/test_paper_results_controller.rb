module QuestionBank
  class TestPaperResultsController < QuestionBank::ApplicationController
    def new
      @test_paper = TestPaper.find(params[:test_paper_id])
      @test_paper_result = @test_paper.test_paper_results.new
    end
  end
end