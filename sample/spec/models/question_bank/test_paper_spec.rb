require 'rails_helper'

RSpec.describe QuestionBank::TestPaper, type: :model do
  describe "基础字段" do
    it{
      @test_paper = create(:test_paper)
      expect(@test_paper.title).to match(/试卷\d+/)
      expect(@test_paper.score).to eq(100)
      expect(@test_paper.minutes).to eq(60)
      expect(@test_paper.respond_to?(:sections)).to eq(true)
    }

    it{
      @test_paper = build(:test_paper, title: '', score: nil, minutes: nil)
      @test_paper.valid?
      expect(@test_paper.errors[:title].size).to eq(1)
      expect(@test_paper.errors[:score].size).to eq(1)
      expect(@test_paper.errors[:minutes].size).to eq(1)
    }
  end

  describe "section question_ids sort" do
    before{
      @q1 = create :question
      @q2 = create :question
      @q3 = create :question

      @s1 = create :section

      @test_paper = create(:test_paper)
      @s1.question_ids << @q1.id
      @s1.question_ids << @q2.id
      @s1.question_ids << @q3.id
      @test_paper.sections << @s1
    }

    it{
      section = QuestionBank::TestPaper.find(@test_paper.id).sections.first
      expect(section.question_ids.map(&:to_s)).to eq([@q1.id.to_s, @q2.id.to_s, @q3.id.to_s])

      @s1.update_attributes(:question_ids_str => "#{@q3.id.to_s},#{@q1.id.to_s},#{@q2.id.to_s}")
      section = QuestionBank::TestPaper.find(@test_paper.id).sections.first
      expect(section.question_ids.map(&:to_s)).to eq([@q3.id.to_s, @q1.id.to_s, @q2.id.to_s])

      section = QuestionBank::TestPaper.find(@test_paper.id).sections.first
      expect(section.questions.map{|q|q.id.to_s}).to eq([@q3.id.to_s, @q1.id.to_s, @q2.id.to_s])
    }
  end
end
