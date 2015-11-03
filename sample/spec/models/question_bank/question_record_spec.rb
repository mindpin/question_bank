require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "成功创建" do 
    before :each do
      @id             = "2354879564145235"
      @bool_answer    = nil
      @choice_answer  = [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
      @essay_answer   = ""
      @fill_answer    = nil
      @mapping_answer = nil
      @content        = "乌龟有几条腿"
      @analysis       = nil
      @level          = 1
      @enabled        = true
      @question = QuestionBank::Question.create(id: @id, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
    end

    it{
      @questions            = @question.id
      @user                 = create(:user).id
      @is_correct           = true
      @bool_answer          = nil
      @choice_answer        = [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )

      @question_record.save
      @question_record.valid?
      
    }

    it{
      @questions            = @question.id
      @user                 = create(:user).id
      @is_correct           = true
      @bool_answer          = nil
      @choice_answer        = [ "S", "s"]
      @essay_answer         = nil
      @fill_answer          = nil
      @mapping_answer       = nil

      @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )

      @question_record.save
      @question_record.valid?
      
    }
  end

  # it{
    #   @questions            = create(:questions)
    #   @user                 = create(:user)
    #   @is_correct           = true
    #   @bool_answer          = true
    #   @choice_answer        = nil
    #   @essay_answer         = nil
    #   @fill_answer          = nil
    #   @mapping_answer       = nil

    #   @question_record = QuestionBank::QuestionRecord.create(
    #   questions: @questions, 
    #   user: @user, 
    #   is_correct: @is_correct, 
    #   bool_answer: @bool_answer,  
    #   choice_answer: @choice_answer, 
    #   essay_answer: @essay_answer, 
    #   fill_answer: @fill_answer, 
    #   mapping_answer: @mapping_answer )

    #   @question_record.valid?
    #   expect(@question_record.errors[:kind].size).to eq(1)

    # }
    # it{
    #   @question_record.destroy
    #   @question_record.valid?
    # }
end