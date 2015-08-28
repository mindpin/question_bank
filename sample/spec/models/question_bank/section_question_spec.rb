require 'rails_helper'

RSpec.describe QuestionBank::Section, type: :model do
  describe "基础字段" do
    it{
      @section = create(:section_question)
      expect(@section.respond_to?(:section_id)).to eq(true)
      expect(@section.respond_to?(:section)).to eq(true)
      expect(@section.respond_to?(:question_id)).to eq(true)
      expect(@section.respond_to?(:question)).to eq(true)
    }
  end

  describe "关系" do
    it{
      @section = create(:section)
      @question = create(:question)
      @section_question1 = create(:section_question, section: @section, question: @question)
      @section_question2 = create(:section_question, section: @section, question: create(:question))

      @section.reload

      expect(@section_question1.section).to eq(@section)
      expect(@section_question2.section).to eq(@section)

      expect(@section_question1.question).to eq(@question)
      expect(@section_question2.section).not_to be_nil

      expect(@section.section_questions).to include(@section_question1)
      expect(@section.section_questions).to include(@section_question2)

      expect(@section.section_questions.count).to eq(2)
    }
  end
end



