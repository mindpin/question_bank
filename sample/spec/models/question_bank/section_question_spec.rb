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
    before do
      @section = create(:section)
      @question1 = create(:question)
      @question2 = create(:question)
      @section_question1 = create(:section_question, section: @section, question: @question1)
      @section_question2 = create(:section_question, section: @section, question: @question2)

      @section.reload
    end

    it{
      expect(@section_question1.section).to eq(@section)
      expect(@section_question2.section).to eq(@section)

      expect(@section_question1.question).to eq(@question1)
      expect(@section_question2.question).to eq(@question2)

      expect(@section.section_questions).to include(@section_question1)
      expect(@section.section_questions).to include(@section_question2)

      expect(@section.section_questions.count).to eq(2)
    }

    it "#questions" do
      expect(@section.questions).to include(@question1)
      expect(@section.questions).to include(@question2)

      expect(@section.questions.count).to eq(2)
    end
  end
end



