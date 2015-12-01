require 'rails_helper'
RSpec.describe QuestionBank::QuestionFlaw, type: :model do
  describe '测试方法' do
    it{
      user = create(:user)
      bool_question = create(:bool_question)
      before_add_count = user.flaw_questions.count
      user.add_flaw_question(bool_question)
      after_add_count = user.flaw_questions.count
      expect(user.flaw_questions.first.question.content).to eq(bool_question.content)
      expect(before_add_count+1).to eq(after_add_count)
      expect(user.flaw_questions.count).to eq(1)
      expect(QuestionBank::QuestionFlaw.where(:user => user,:question => bool_question).first.present?).to eq(true)
      user.remove_flaw_question(bool_question)
      expect(user.flaw_questions.count).to eq(0)
      expect(QuestionBank::QuestionFlaw.where(:user => user,:question => bool_question).first.present?).to eq(false)
    }
  end
end