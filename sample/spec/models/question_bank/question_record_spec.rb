require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "基础字段" do
    it{
      @question_record = create(:question_record)
      expect(@question_record.respond_to?(:question_id)).to eq(true)
      expect(@question_record.respond_to?(:user_id)).to eq(true)
      expect(@question_record.respond_to?(:is_correct)).to eq(true)
      expect(@question_record.respond_to?(:bool_answer)).to eq(true)
      expect(@question_record.respond_to?(:single_choice_answer)).to eq(true)
      expect(@question_record.respond_to?(:multi_choice_answer)).to eq(true)
      expect(@question_record.respond_to?(:essay_answer)).to eq(true)
      expect(@question_record.respond_to?(:fill_answer)).to eq(true)
      expect(@question_record.respond_to?(:mapping_answer)).to eq(true)
    }
  end

  describe "成功创建(判断题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = true
      @single_choice_answer = nil
      @multi_choice_answer  = nil
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end

  describe "成功创建(单选题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = ["A"]
      @multi_choice_answer  = nil
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end
  describe "成功创建(多选题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = nil
      @multi_choice_answer  = ["A","B","C"]
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end

  describe "成功创建(论述题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = nil
      @multi_choice_answer  = nil
      @essay_answer         = "This question is very good"
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end

  describe "成功创建(填空题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = nil
      @multi_choice_answer  = nil
      @essay_answer         = nil
      @fill_answer          = ["拿破仑","希特勒","成吉思汗"]
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end

  describe "成功创建(连线题的记录)" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = nil
      @multi_choice_answer  = nil
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = [["A","B"],["C","D"],["E","F"]]

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.save
      @question_record.valid?
    }
  end

  describe "成功删除" do 
    before :each do 
      @question_id          = "1234562789542136"
      @user_id              = "2543215879654125"
      @is_correct           = true
      @bool_answer          = nil
      @single_choice_answer = ["A"]
      @multi_choice_answer  = nil
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(question_id: @question_id, user_id: @user_id, is_correct: @is_correct, bool_answer: @bool_answer, single_choice_answer: @single_choice_answer, multi_choice_answer: @multi_choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer)
    end

    it{
      question = @question_record.clone
      question.destroy
      @question_record.valid?
    }
  end
end