require 'rails_helper'

RSpec.describe QuestionBank::Question, type: :model do
  describe '基础字段校验' do
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:answer) }
    it { is_expected.to have_field(:enabled).with_default_value_of(false) }
  end

  describe '单选题' do
    it "正确格式" do
      attrs = {
        level: "3",
        kind: "single_choice",
        content: "题目内容",
        answer: {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "correct" => "aaa"
        }
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "错误格式" do
      answers = [
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ]
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "correct" => "aaa",
          "b" => 1
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "correct" => "aaa"
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
              "a"       => 123
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "correct" => "aaa"
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "correct" => "eee"
        },
        "",
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "single_choice",
          content: "题目内容",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end
  end

  describe "多选题" do
    it "正确格式" do
      attrs = {
        level: "3",
        kind: "multi_choice",
        content: "题目内容",
        answer: {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "corrects" => ["aaa","bbb"]
        }
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "错误格式" do
      answers = [
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ]
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "corrects" => ["aaa","bbb"],
          "b" => 1
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "corrects" => ["aaa","bbb"],
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
              "a"       => 123
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "corrects" => ["aaa","bbb"],
        },
        {
          "choices" => [
            {
              "id"      => "aaa", # 随机字符串
              "text"    => "选项一",
            },
            {
              "id"      => "bbb",
              "text"    => "选项二",
            },
            {
              "id"      => "ccc",
              "text"    => "选项三",
            },
            {
              "id"      => "ddd",
              "text"    => "选项四",
            }
          ],
          "corrects" => ["aaa","eee"],
        },
        "",
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "multi_choice",
          content: "题目内容",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end

  end

  describe "连线题" do
    it "格式正确" do
      attrs = {
        level: "3",
        kind: "mapping",
        content: "题目内容",
        answer: {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ]
        }
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "格式错误" do
      answers = [
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ],
          "a" => 1
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一",
              "a" => 1
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "ggg"
            }
          ]
        },
        {
          "left" => [
            {
              "id" => "aaa", # 随机字符串
              "text" => "左选项一"
            },
            {
              "id"=> "bbb", # 随机字符串
              "text"=> "左选项二"
            },
            {
              "id"=>"ccc", # 随机字符串
              "text"=> "左选项三"
            }
          ],
          "right" => [
            {
              "id"=> "ddd", # 随机字符串
              "text"=> "右选项一"
            },
            {
              "id"=> "eee", # 随机字符串
              "text"=> "右选项二"
            },
            {
              "id"=> "fff", # 随机字符串
              "text"=> "右选项三"
            }
          ],
          "mappings" => [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "fff"
            },
            {
              "left"  => "ccc",
              "right" => "fff"
            }
          ]
        }
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "mapping",
          content: "题目内容",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end
  end

  describe "判断题" do
    it "正确格式" do
      attrs = {
        level: "3",
        kind: "bool",
        content: "题目内容",
        answer: true
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "错误格式" do
      answers = [
        123,
        "abc",
        ""
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "bool",
          content: "题目内容",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end
  end

  describe "填空题" do
    it "正确格式" do
      attrs = {
        level: "3",
        kind: "fill",
        content: "题目___内容___",
        answer: ["a","b"]
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "错误格式" do
      answers = [
        ["a"],
        ["a","b","c"],
        ""
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "fill",
          content: "题目___内容___",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end
  end

  describe "论述题" do
    it "正确格式" do
      attrs = {
        level: "3",
        kind: "essay",
        content: "题目内容",
        answer: "aaa"
      }
      question = QuestionBank::Question.create(attrs)
      expect(question.valid?).to eq(true)
    end

    it "错误格式" do
      answers = [
        ["123"]
      ]

      answers.each do |answer|
        attrs = {
          level: "3",
          kind: "essay",
          content: "题目内容",
          answer: answer
        }
        question = QuestionBank::Question.create(attrs)
        expect(question.valid?).to eq(false)
      end

    end
  end

end
