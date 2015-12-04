require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "单选题" do
    before :all do
      @question = create :single_choice_question_wugui
      @user     = create(:user)
    end
    describe "回答正确" do
      before :all do
        @choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "true"]}
        @record = @question.question_records.create(
          :user          => @user,
          :answer        => @choice_answer
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
        expect(@record.choice_answer).to eq(
          [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
        )
      }
    end

    describe "回答错误" do
      before :context do
        @choice_answer = {"0" => ["一条", "true"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "false"]}
        @record = @question.question_records.create(
          :user   => @user,
          :answer => @choice_answer
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
        expect(@record.choice_answer).to eq(
          [["一条", true], ["两条", false], ["三条", false], ["四条", false]]
        )
      }
    end

    describe "choice_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :essay_answer => "abc",
          :fill_answer => ["bcd"],
          :mapping_answer => [["狐狸", "犬科"], ["老虎", "猫科"]],
          :bool_answer => "true"
        }

        answer_fields.each do |field|
          choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "true"]}
          record = @question.question_records.create(
            :user   => @user,
            :answer => choice_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end

    describe "答案格式不正确" do
      before :all do
        @choice_answers = [
          {"0" => ["1"]},
          {"0" => [true,"true"]},
          {"0" =>["一条", "true"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "true"]}
        ]
      end

      it{
        @choice_answers.each do |answer|
          record = @question.question_records.create(
            :user   => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:single_choice_answer]).not_to be_nil
        end
      }
    end
  end

  describe "多选题" do
    before :all do
      @question = create :multi_choice_question_xiaochao
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "true"], "2" => ["三条", "true"], "3" => ["四条", "true"], "4" => ["五条", "true"]}
        @record = @question.question_records.create(
          :user   => @user,
          :answer => @choice_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.bool_answer).to eq(nil)
        expect(@record.fill_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.choice_answer).to eq(
          [["一条", false], ["两条", true], ["三条", true], ["四条", true], ["五条", true]]
        )
      }
    end

    describe "回答错误" do
      before :all do
        @choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "false"], "2" => ["三条", "true"], "3" => ["四条", "true"], "4" => ["五条", "true"]}
        @record = @question.question_records.create(
          :user   => @user,
          :answer => @choice_answer
        )
      end
      it{
        expect(@record.valid?).to eq(true)
      }
      it{
        expect(@record.kind).to eq(@question.kind)
      }
      it{
        expect(@record.is_correct).to eq(false)
      }
      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.bool_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.choice_answer).to eq(
          [["一条", false], ["两条", false], ["三条", true], ["四条", true], ["五条", true]]
        )
      }
    end

    describe "choice_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :essay_answer   => "Yes,he has two legs",
          :fill_answer    => ["a leg"],
          :bool_answer    => true,
          :mapping_answer => [["a","leg"],["two","legs"]]
        }
        answer_fields.each do |field|
          choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "true"], "2" => ["三条", "true"], "3" => ["四条", "true"], "4" => ["五条", "true"]}
          record = @question.question_records.create(
            :user    => @user,
            :answer  => choice_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end

    describe "答案格式不正确" do
      it{
        choice_answer = [
          {"0" => ["leg"]},
          {"0" =>[true,"two legs"]},
          {"0" => ["一条", "false"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "false"], "4" => ["五条", "true"]}
        ]
        choice_answer.each do |answer|
          record = @question.question_records.create(
            :user  => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:multi_choice_answer]).not_to be_nil
        end
      }
    end
  end

  describe "填空题" do
    before :all do
      @question = create :fill_question_say_hello
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @fill_answer = ["北京", "伦敦"]
        @record      = @question.question_records.create(
          :user   => @user,
          :answer => @fill_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.fill_answer).to eq(@fill_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @fill_answer = ["上海", "苏格兰"]
        @record      = @question.question_records.create(
          :user   => @user,
          :answer => @fill_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.fill_answer).to eq(@fill_answer)
      }
    end

    describe "fill_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :choice_answer => [["hello",true],["nihao",false]],
          :mapping_answer => [["hony","baby"],["coat","shirt"]],
          :bool_answer => true,
          :essay_answer => "Alan is a good man"
        }
        answer_fields.each do |field|
          fill_answer = ["北京", "伦敦"]
          record = @question.question_records.create(
            :user => @user,
            :answer =>fill_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end

    describe "答案格式不正确" do
      it{
        fill_answers = [
          [true,1452],
          [["北京"],["伦敦"]]
        ]
        fill_answers.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:fill_answer]).not_to be_nil
        end
      }
    end
  end

  describe "连线题" do
    before :all do
      @question = create :mapping_question_letter
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @mapping_answer = {"0" => ["A","a"],"1" =>["B", "b"], "2" =>["C", "c"]}
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(
          [["A","a"], ["B", "b"], ["C", "c"]]
        )
      }
    end

    describe "回答错误" do
      before :all do
        @mapping_answer = {"0" => ["A","b"],"1" =>["B", "c"], "2" =>["C", "a"]}
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.bool_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(
          [["A","b"], ["B", "c"], ["C", "a"]]
        )
      }
    end

    describe "mapping_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :fill_answer => ["peking"],
          :bool_answer => true,
          :essay_answer => "I love you sweet",
          :choice_answer => [["一条", false], ["两条", false], ["三条", false], ["四条", true]],
        }
        @mapping_answer = {"0" => ["A","a"],"1" =>["B", "b"], "2" =>["C", "c"]}
        answer_fields.each do |field|
          record = @question.question_records.create(
            :user => @user,
            :answer => @mapping_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end

    describe "答案格式不正确" do
      it{
        mapping_answer = [
          {"0" => ["hello"]},
          {"0" => ["hei",true],"1" => [345,true]},
          {"0" => [nil,nil],"1" => [nil,nil]}
        ]
        mapping_answer.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:mapping_answer]).not_to be_nil
        end
      }
    end
  end

  describe "论述题" do
    before :all do
      @question = create :essay_question_relative
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @essay_answer = "很关键"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.bool_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.essay_answer).to eq(@essay_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @essay_answer = "I don't know"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.bool_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.essay_answer).to eq(@essay_answer)
      }
    end

    describe "essay_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :bool_answer => true,
          :fill_answer => ["right"],
          :mapping_answer => [["A","a"],["B","b"]],
          :choice_answer => [["two",false],["four",false],["three",true],["one",false]]
        }
        @essay_answer = "很关键"
        answer_fields.each do |field|
          record = @question.question_records.create(
            :user => @user,
            :answer => @essay_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end
  end

  describe "判断题" do
    before :all do
      @question = create :bool_question_dog
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @bool_answer = "true"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.bool_answer).to eq(true)
      }
    end

    describe "回答错误" do
      before :all do
        @bool_answer = "false"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.fill_answer).to eq(nil)
        expect(@record.mapping_answer).to eq(nil)
        expect(@record.choice_answer).to eq(nil)
        expect(@record.essay_answer).to eq(nil)
        expect(@record.bool_answer).to eq(false)
      }
    end

    describe "bool_answer 字段之外的答案字段必须为 nil" do
      it{
        answer_fields = {
          :fill_answer => ["abc"],
          :mapping_answer => [["A","a"],["B","b"],["C","c"]],
          :choice_answer => [["jkl",true],["ghi",false],["def",false],["abc",false]],
          :essay_answer => "Hello world"
        }
        @bool_answer = true
        answer_fields.each do |field|
          record = @question.question_records.create(
            :user => @user,
            :answer => @bool_answer,
            field[0] => field[1]
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[field[0]]).not_to be_nil
        end
      }
    end
  end

  describe "测试 with_created_at 方法" do 
    before :example do
      @user          = create :user
      @question      = create :essay_question_relative
      @essay_answer1 ="很关键"
      @essay_answer2 ="很重要"
      @essay_answer3 ="不能没有"
      @day_1 = Time.local(2015, 11, 28, 10, 0, 0)
      @day_2 = Time.local(2015, 12, 02, 10, 0, 0)
      @day_3 = Time.local(2015, 12, 06, 10, 0, 0)
      @temp  = []
      [
        [@day_1,@essay_answer1],
        [@day_2,@essay_answer2],
        [@day_3,@essay_answer3]
      ].each do |arr|
        Timecop.freeze(arr[0]) do
          @record = @question.question_records.create(
            :user => @user,
            :answer => arr[1]
          )
          @temp.push(@record)
        end
      end
    end
    it{
      expect(@temp.count).to eq(3)
    }

    describe "成功" do
      it{
        @start_time = @day_1
        @end_time = @day_3
        @batch_search = QuestionBank::QuestionRecord.with_created_at(@start_time.to_time, @end_time.to_time)
        expect(@batch_search.count).to eq(3)
      }

      it{
        @start_time = @day_2
        @end_time = nil
        @batch_search = QuestionBank::QuestionRecord.with_created_at(@start_time.to_time, @end_time)
        expect(@batch_search.count).to eq(2)
      }

      it{
        @start_time = nil
        @end_time = @day_2
        @batch_search = QuestionBank::QuestionRecord.with_created_at(@start_time, @end_time.to_time)
       expect(@batch_search.count).to eq(2)
      }
    end

    describe "失败" do 
      it{
        @start_time = nil
        @end_time   = nil
        @batch_search = QuestionBank::QuestionRecord.with_created_at(@start_time, @end_time)
        expect(@batch_search.count).to eq(0)
      }
    end
  end

  describe "测试 with_kind 方法" do
    before :example do
      @user     = create :user
    end

    describe "kind 为 bool" do
      it{
        @question = create :bool_question_dog
        @bool_answer = "false"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("bool")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 single_choice" do
      it{
        @question = create :single_choice_question_wugui
        @choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "false"], "2" => ["三条", "false"], "3" => ["四条", "true"]}
        @record = @question.question_records.create(
          :user => @user,
          :answer => @choice_answer
        ) 
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("single_choice")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 multi_choice" do
      it{
        @question = create :multi_choice_question_xiaochao
        @choice_answer = {"0" => ["一条", "false"], "1" => ["两条", "true"], "2" => ["三条", "true"], "3" => ["四条", "true"], "4" => ["五条", "true"]}
        @record = @question.question_records.create(
          :user => @user,
          :answer => @choice_answer
        ) 
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("multi_choice")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 fill" do
      it{
        @question = create :fill_question_say_hello
        @fill_answer = ["北京", "伦敦"]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @fill_answer
        ) 
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("fill")
        expect(@kind_search.first).to eq(@record)
      }
    end    

    describe "kind 为 mapping" do
      it{
        @question = create :mapping_question_letter
        @mapping_answer = {"0" => ["A","a"],"1" =>["B", "b"], "2" =>["C", "c"]}
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        ) 
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("mapping")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 essay" do
      it{
        @question = create :essay_question_relative
        @essay_answer = "很关键"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        ) 
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("essay")
        expect(@kind_search.first).to eq(@record)
      }
    end
  end

  describe "测试 with_correct 方法" do
    before :example do
      @user     = create :user
      @question = create :bool_question_dog 
    end

    it{
      @bool_answers = [
        "false",
        "true"
      ]
      @bool_answers.each do |answer|
        record      = @question.question_records.create(
          :user   => @user,
          :answer => answer
        )
        expect(record.valid?).to eq(true)
        wheater_correct = QuestionBank::QuestionRecord.with_correct(answer)
        expect(wheater_correct.first).to eq(record)
      end
    }
  end
end
