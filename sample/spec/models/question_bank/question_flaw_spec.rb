require 'rails_helper'
RSpec.describe QuestionBank::QuestionFlaw, type: :model do
  describe 'UserMethods' do
    before :example do
      @user = create(:user)
      @bool_question = create(:bool_question)
    end

    describe 'user.add_flaw_question(question)' do
      it{
        before_add_count = @user.question_flaws.count
        @user.add_flaw_question(@bool_question)
        after_add_count = @user.question_flaws.count
        expect(@user.question_flaws.first.question.content).to eq(@bool_question.content)
        expect(before_add_count+1).to eq(after_add_count)
        expect(@user.question_flaws.count).to eq(1)
        expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(true)
      }
    end

    describe 'user.remove_flaw_question(question)' do
      it{
        @user.add_flaw_question(@bool_question)
        @user.remove_flaw_question(@bool_question)
        expect(@user.flaw_questions.count).to eq(0)
        expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(false)
      }
    end

    describe 'question.is_in_flaw_list_of?(user)' do
      it{
        QuestionBank::QuestionFlaw.create(:user => @user,:question => @bool_question)
        expect(@bool_question.is_in_flaw_list_of?(@user)).to eq(true)
      }
    end

    # 测试冗余字段
    describe '冗余字段' do
      it{
        flaw = QuestionBank::QuestionFlaw.create(:user => @user,:question => @bool_question)
        expect(flaw.kind).to eq(@bool_question.kind)
      }
    end
    # 测试方法
    describe 'user.flaw_questions' do
      it{
        @bool_question = create(:bool_question)
        @choice_question = create(:single_choice_question_wugui)
        before_add_2_question_count = @user.flaw_questions.count
        @user.add_flaw_question(@bool_question)
        @user.add_flaw_question(@choice_question)
        after_add_2_question_count = @user.flaw_questions.count
        expect(@user.flaw_questions.where(:kind => "single_choice").first.content).to eq(@choice_question.content)
        expect(@user.flaw_questions.where(:kind => "bool").first.content).to eq(@bool_question.content)
        expect(before_add_2_question_count+2).to eq(after_add_2_question_count)
      }
    end
  end
end
