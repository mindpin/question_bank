require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "基础字段" do
    it{
      @question_record = create(:question_record)
      expect(@question_record.respond_to?(:question_id)).to eq(true)
      expect(@question_record.respond_to?(:question)).to eq(true)
      expect(@question_record.respond_to?(:user_id)).to eq(true)
      expect(@question_record.respond_to?(:user)).to eq(true)
      expect(@question_record.respond_to?(:is_correct)).to eq(true)
      expect(@question_record.respond_to?(:bool_answer)).to eq(true)
      expect(@question_record.respond_to?(:choice_answer)).to eq(true)
      expect(@question_record.respond_to?(:essay_answer)).to eq(true)
      expect(@question_record.respond_to?(:fill_answer)).to eq(true)
      expect(@question_record.respond_to?(:mapping_answer)).to eq(true)
    }
  end

  describe "成功创建" do 
    before :each do 

      @question             = create(:question)
      @user                 = create(:user)
      @is_correct           = true
      @bool_answer          = true
      @choice_answer        = nil
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.create(
        question: @question_id, 
        user: @user_id, 
        is_correct: @is_correct, 
        bool_answer: @bool_answer,  
        choice_answer: @choice_answer, 
        essay_answer: @essay_answer, 
        fill_answer: @fill_answer, 
        mapping_answer: @mapping_answer
      )
    end

    it{
      @question_record.valid?
    }

    it{
      @question_record.destroy
      @question_record.valid?
    }
  end
end