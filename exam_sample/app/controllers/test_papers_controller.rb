class TestPapersController < ApplicationController
  def index
    @test_papers = QuestionBank::TestPaper.recent.page params[:page]
  end

  def new
    @test_paper = QuestionBank::TestPaper.new
  end

  def create
    @test_paper = QuestionBank::TestPaper.new test_paper_params
    if @test_paper.save
      redirect_to @test_paper
    else
      render :new
    end
  end

  def show
    @test_paper = QuestionBank::TestPaper.find params[:id]
  end

  def edit
    @test_paper = QuestionBank::TestPaper.find params[:id]
  end

  def update
    @test_paper = QuestionBank::TestPaper.find params[:id]
    if @test_paper.update_attributes test_paper_params
      redirect_to @test_paper
    else
      render :edit
    end
  end

  def destroy
    @test_paper = QuestionBank::TestPaper.find params[:id]
    @test_paper.destroy
    redirect_to test_papers_path
  end

  def preview
    @test_paper = QuestionBank::TestPaper.new test_paper_params
    render :show
  end

  private
  def test_paper_params
    params.require(:test_paper).permit(:title, :score, :minutes, :sections_attributes => [:kind, :score, :min_level, :max_level, :position, :id, :_destroy, :question_ids_str])
  end
end
