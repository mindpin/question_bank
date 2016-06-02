require 'rails_helper'

RSpec.describe QuestionBank::Point, type: :model do
  it { should validate_presence_of :name }

  it "属性" do
    @point = create(:point)
    expect(@point.respond_to?(:name)).to be true
  end

  describe "方法" do
    describe QuestionBank::Point::QuestionMethods, type: :module do
      it "question.points" do
        @question = create(:question)
        expect(@question.respond_to?(:points)).to be true
      end

      it "Question.with_point" do
        expect(QuestionBank::Question.respond_to?(:with_point)).to be true
        expect(QuestionBank::Question.with_point(nil)).to_not be_any
        expect(QuestionBank::Question.with_point("whatever")).to_not be_any

        @question = create(:question)
        @point = create(:point)
        @question.points << @point
        expect(QuestionBank::Question.with_point(@point.name)).to be_any
      end
    end
  end
end
