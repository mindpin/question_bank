class TestPaperResultsController < ApplicationController
  def new
    @test_paper = TestPaper.find(params[:test_paper_id])
    @test_paper_result = @test_paper.test_paper_results.new
  end

  def create
    params.permit!
    test_paper = TestPaper.find(params[:test_paper_id])
    test_paper_result = test_paper.test_paper_results.new(:question_records_attributes => params[:test_paper_result][:question_records_attributes])
    test_paper_result.user = current_user
    test_paper_result.save
    render :json => test_paper_result.to_create_hash
  end

end
