require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "单选题" do
    before :all do
      @question = create :single_choice_question_wugui
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @choice_answer = [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
        @record = @question.question_records.create(
          :user          => @user,
          :choice_answer => @choice_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct?).to eq(true)
      }

      it{
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.fill_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(@choice_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @choice_answer = [["一条", true], ["两条", false], ["三条", false], ["四条", false]]
        @record = @question.question_records.create(
          :user          => @user,
          :choice_answer => @choice_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct?).to eq(false)
      }

      it{
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.fill_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(@choice_answer)
      }
    end

    describe "choice_answer 字段之外的答案字段必须为 nil" do
      before :all do
        @choice_answer = [["一条", true], ["两条", false], ["三条", false], ["四条", false]]
        @record = @question.question_records.create(
          :user          => @user,
          :choice_answer => @choice_answer,
          :essay_answer  => "abc"
        )
      end

      it{
        expect(@record.valid?).to eq(false)
      }

      it{
        expect(@record.errors.messages[:essay_answer]).not_to be_nil
      }
    end

  end

  # describe "多选题" do
  #   before :each do
  #     @id             = "2354879564145236"
  #     @kind           = "multi_choice"
  #     @choice_answer  = [["一条", false], ["两条", true], ["三条", true], ["四条", true], ["五条", true]]
  #     @content        = "小超有几条腿"
  #     @analysis       = nil
  #     @level          = 1
  #     @enabled        = true
  #     @question = QuestionBank::Question.create(id: @id, kind: @kind, choice_answer: @choice_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
  #   end
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = true
  #     @bool_answer          = nil
  #     @choice_answer        = [["一条", false], ["两条", true], ["三条", true], ["四条", true], ["五条", true]]
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db.user).to eq(@user)
  #     expect(@question_record_db.is_correct).to eq(@is_correct)
  #     expect(@question_record_db.bool_answer).to eq(@bool_answer)
  #     expect(@question_record_db.choice_answer).to eq(@choice_answer)
  #     expect(@question_record_db.essay_answer).to eq(@essay_answer)
  #     expect(@question_record_db.fill_answer).to eq(@fill_answer)
  #     expect(@question_record_db.mapping_answer).to eq(@mapping_answer)
  #   }
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = false
  #     @bool_answer          = nil
  #     @choice_answer        = ["1","2"]
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db).to eq(nil)
  #   }
  # end
  #
  # describe "填空题" do
  #   before :each do
  #     @id             = "2354879564145220"
  #     @kind           = "fill"
  #     @fill_answer    = ["nihao", "hello"]
  #     @content        = "你好___Hello___"
  #     @analysis       = nil
  #     @level          = 1
  #     @enabled        = true
  #     @question = QuestionBank::Question.create(id: @id, kind: @kind, fill_answer: @fill_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
  #   end
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = true
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = ["nihao", "hello"]
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db.questions).to eq(@questions)
  #     expect(@question_record_db.user).to eq(@user)
  #     expect(@question_record_db.is_correct).to eq(@is_correct)
  #     expect(@question_record_db.bool_answer).to eq(@bool_answer)
  #     expect(@question_record_db.choice_answer).to eq(@choice_answer)
  #     expect(@question_record_db.essay_answer).to eq(@essay_answer)
  #     expect(@question_record_db.fill_answer).to eq(@fill_answer)
  #     expect(@question_record_db.mapping_answer).to eq(@mapping_answer)
  #   }
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = false
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = [123]
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new( questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db).to eq(nil)
  #   }
  # end
  #
  # describe "连线题" do
  #   before :each do
  #     @id             = "2254879564145210"
  #     @kind           = "mapping"
  #     @mapping_answer = [["bbbb", "bbbb"], ["cccccc", "dddddd"]]
  #     @content        = "yyybby3331213131"
  #     @analysis       = nil
  #     @level          = 1
  #     @enabled        = true
  #     @question = QuestionBank::Question.create(id: @id, kind: @kind,mapping_answer: @mapping_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
  #   end
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = true
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = [["bbbb", "bbbb"], ["cccccc", "dddddd"]]
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db.user).to eq(@user)
  #     expect(@question_record_db.is_correct).to eq(@is_correct)
  #     expect(@question_record_db.bool_answer).to eq(@bool_answer)
  #     expect(@question_record_db.choice_answer).to eq(@choice_answer)
  #     expect(@question_record_db.essay_answer).to eq(@essay_answer)
  #     expect(@question_record_db.fill_answer).to eq(@fill_answer)
  #     expect(@question_record_db.mapping_answer).to eq(@mapping_answer)
  #   }
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = false
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = ["niao"]
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db).to eq(nil)
  #   }
  # end
  #
  # describe "论述题" do
  #   before :each do
  #     @id             = "2354879564145238"
  #     @kind           = "essay"
  #     @essay_answer   = "很关键"
  #     @content        = "论亲情"
  #     @analysis       = nil
  #     @level          = 1
  #     @enabled        = true
  #     @question = QuestionBank::Question.create(id: @id, kind: @kind, essay_answer: @essay_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
  #   end
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = true
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = "很美好"
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db.questions).to eq(@questions)
  #     expect(@question_record_db.user).to eq(@user)
  #     expect(@question_record_db.is_correct).to eq(@is_correct)
  #     expect(@question_record_db.bool_answer).to eq(@bool_answer)
  #     expect(@question_record_db.choice_answer).to eq(@choice_answer)
  #     expect(@question_record_db.essay_answer).to eq(@essay_answer)
  #     expect(@question_record_db.fill_answer).to eq(@fill_answer)
  #     expect(@question_record_db.mapping_answer).to eq(@mapping_answer)
  #   }
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = false
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db).to eq(nil)
  #   }
  # end
  #
  # describe "判断题" do
  #   before :each do
  #     @id             = "2354879564145321"
  #     @kind           = "bool"
  #     @bool_answer    = true
  #     @content        = "阿黄是否小狗"
  #     @analysis       = nil
  #     @level          = 1
  #     @enabled        = true
  #     @question = QuestionBank::Question.create(id: @id, kind: @kind, bool_answer: @bool_answer, content: @content, analysis: @analysis, level: @level, enabled: @enabled )
  #   end
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = false
  #     @bool_answer          = false
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db.questions).to eq(@questions)
  #     expect(@question_record_db.user).to eq(@user)
  #     expect(@question_record_db.is_correct).to eq(@is_correct)
  #     expect(@question_record_db.bool_answer).to eq(@bool_answer)
  #     expect(@question_record_db.choice_answer).to eq(@choice_answer)
  #     expect(@question_record_db.essay_answer).to eq(@essay_answer)
  #     expect(@question_record_db.fill_answer).to eq(@fill_answer)
  #     expect(@question_record_db.mapping_answer).to eq(@mapping_answer)
  #   }
  #
  #   it{
  #     @questions            = @question
  #     @user                 = create(:user)
  #     @is_correct           = true
  #     @bool_answer          = nil
  #     @choice_answer        = nil
  #     @essay_answer         = nil
  #     @fill_answer          = nil
  #     @mapping_answer       = nil
  #
  #     @question_record = QuestionBank::QuestionRecord.new(questions: @questions, user: @user, is_correct: @is_correct, bool_answer: @bool_answer, choice_answer: @choice_answer, essay_answer: @essay_answer, fill_answer: @fill_answer, mapping_answer: @mapping_answer )
  #
  #     @question_record.save
  #     @question_record.valid?
  #     @question_record_db = QuestionBank::QuestionRecord.where(:questions =>@questions).first
  #     expect(@question_record_db).to eq(nil)
  #   }
  # end

end
