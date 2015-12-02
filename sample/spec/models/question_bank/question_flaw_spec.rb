require 'rails_helper'
RSpec.describe QuestionBank::QuestionFlaw, type: :model do
  describe 'UserMethods' do
    before :all do
      @user = create(:user)
      @bool_question = create(:bool_question)
    end

    describe '测试方法add_flaw_question' do
      it{
      before_add_count = @user.flaw_questions.count
      @user.add_flaw_question(@bool_question)
      @user.add_flaw_question(@bool_question)
      after_add_count = @user.flaw_questions.count
      expect(@user.flaw_questions.first.question.content).to eq(@bool_question.content)
      expect(before_add_count+1).to eq(after_add_count)
      expect(@user.flaw_questions.count).to eq(1)
      expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(true)
      }
    end

    describe '测试方法remove_flaw_question' do
      it{
      @user.add_flaw_question(@bool_question)
      @user.remove_flaw_question(@bool_question)
      @user.remove_flaw_question(@bool_question)
      expect(@user.flaw_questions.count).to eq(0)
      expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(false)
      }
    end

    describe 'QuestionMethods::is_in_flaw_list_of?' do
      it{
        QuestionBank::QuestionFlaw.create(:user => @user,:question => @bool_question)
        expect(@bool_question.is_in_flaw_list_of?(@user)).to eq(true)
      }
    end
  end

  describe "测试 with_created_at 方法" do 
    before :example do
      @user     = create :user
      @question = create :bool_question_dog
      @flaw = @question.question_flaws.create(
        :user => @user
      )
    end

    it{
      expect(@flaw.valid?).to eq(true)
    }

    describe "成功" do
      it{
        @start_time = "2015-12-01"
        @end_time = Time.now
        @batch_search = QuestionBank::QuestionFlaw.with_created_at(@start_time.to_time, @end_time.to_time).to_a
        expect(@batch_search).to eq(@flaw.to_a)
      }

      it{
        @start_time = "2015-12-02"
        @end_time = nil
        @batch_search = QuestionBank::QuestionFlaw.with_created_at(@start_time.to_time, @end_time).to_a
        expect(@batch_search).to eq(@flaw.to_a)
      }

      it{
        @start_time = nil
        @end_time = "2015-12-02"
        @batch_search = QuestionBank::QuestionFlaw.with_created_at(@start_time, @end_time).to_a
        expect(@batch_search).to eq(@flaw.to_a)
      }
    end

    describe "失败" do 
      it{
        @start_time = nil
        @end_time   = nil
        @batch_search = QuestionBank::QuestionFlaw.with_created_at(@start_time, @end_time)
        expect(@batch_search.count).to eq(0)
      }
    end
  end
end
