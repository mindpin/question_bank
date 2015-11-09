require 'rails_helper'
RSpec.describe QuestionBank::QuestionFlaw, type: :model do
  describe '测试方法' do
    it{
      p '验证 .flaw_questions和.add_flaw_question(xxx)'
      user = create(:user)
      bool_question = create(:bool_question)
      before_add_count = user.flaw_questions.count
      user.add_flaw_question(bool_question)
      after_add_count = user.flaw_questions.count
      expect(user.flaw_questions.first.question.content).to eq(bool_question.content)
      expect(before_add_count+1).to eq(after_add_count)

      p '验证.remove_flaw_question(xxx)'
      expect(user.flaw_questions.count).to eq(1)
      p user.flaw_questions
      expect(QuestionBank::QuestionFlaw.where(:user => user,:question => bool_question).first.present?).to eq(true)
      user.remove_flaw_question(bool_question)
      expect(user.flaw_questions.count).to eq(0)
      p user.flaw_questions
      expect(QuestionBank::QuestionFlaw.where(:user => user,:question => bool_question).first.present?).to eq(false)
      p 'user.flaw_questions 这东西只有重新访问数据库才能起作用'
    }
  end
end