module QuestionBank
  class TestPapersController < QuestionBank::ApplicationController
    def index
      @test_papers = QuestionBank::TestPaper.all
    end

    def new
      @test_paper = QuestionBank::TestPaper.new
      @test_paper.sections.new
      @section = @test_paper.sections.new
      @section.section_questions.new question_id: QuestionBank::Question.first.id
      @section.section_questions.new question_id: QuestionBank::Question.last.id
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

    private
      def test_paper_params
        params.require(:test_paper).permit(:title, :score, :minutes, :sections_attributes => [:kind, :score, :min_level, :max_level, :section_questions_attributes => [:question_id, :_destroy]])
      end
  end
end
