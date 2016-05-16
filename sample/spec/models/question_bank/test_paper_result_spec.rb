require 'rails_helper'

RSpec.describe QuestionBank::TestPaperResult, type: :model do
  describe "test_paper_result 中的做题记录只能在考试时间内提交" do
    before{
      @test_paper = create(:test_paper_with_questions)
      @user       = create(:user)
    }
    it{
      created_at = Time.local(2015, 12, 07, 10, 0, 0)
      Timecop.freeze(created_at) do
        @tpr = QuestionBank::TestPaperResult.create(
          user: @user,
          test_paper: @test_paper
        )
      end

      Timecop.freeze(created_at + 10) do
        question = @test_paper.sections.first.questions.first
        qr = QuestionBank::QuestionRecord.create(
          test_paper_result: @tpr,
          question: question,
          user: @user,
          answer: question.answer["correct"]
        )
        expect(qr.valid?).to eq(true)
      end

      Timecop.freeze(created_at + 10 + @test_paper.minutes.minutes) do
        question = @test_paper.sections.first.questions.last
        qr = QuestionBank::QuestionRecord.create(
          test_paper_result: @tpr,
          question: question,
          user: @user,
          answer: question.answer["correct"]
        )
        expect(qr.valid?).to eq(false)
      end

    }
  end

end
