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
end

