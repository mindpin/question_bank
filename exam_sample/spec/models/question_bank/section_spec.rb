require 'rails_helper'

RSpec.describe QuestionBank::Section, type: :model do
  describe "基础字段" do
    it{
      @section = create(:section)
      expect(@section.kind).to eq('single_choice')
      expect(@section.score).to eq(5)
      expect(@section.min_level).to eq(1)
      expect(@section.max_level).to eq(10)
      expect(@section.respond_to?(:test_paper)).to eq(true)
      expect(@section.respond_to?(:questions)).to eq(true)
    }

    it{
      @section = build(:section, kind: nil, score: nil, min_level: nil, max_level: nil)
      @section.valid?
      expect(@section.errors[:kind].size).to eq(1)
      expect(@section.errors[:score].size).to eq(1)
      expect(@section.errors[:min_level].size).to eq(1)
      expect(@section.errors[:max_level].size).to eq(1)
    }
  end
end
