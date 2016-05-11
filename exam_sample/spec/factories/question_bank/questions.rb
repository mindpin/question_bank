FactoryGirl.define do
  factory :question, class: QuestionBank::Question do
    kind :single_choice
    sequence(:content){|n| "单选题#{n}"}
    enabled true
    level 2
    answer( {
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
    })
  end

  #
  factory :single_choice_question, class: QuestionBank::Question do
    kind "single_choice"
    content "乌龟有几条腿"
    level 1
    enabled true
    answer( {
      "choices" => [
        {
          "id"      => "aaa", # 随机字符串
          "text"    => "一条",
        },
        {
          "id"      => "bbb",
          "text"    => "两条",
        },
        {
          "id"      => "ccc",
          "text"    => "三条",
        },
        {
          "id"      => "ddd",
          "text"    => "四条",
        }
      ],
      "correct" => "ddd"
    })
  end
  #
  factory :multi_choice_question, class: QuestionBank::Question do
    kind "multi_choice"
    content "小超有几条腿"
    level 1
    enabled true
    answer( {
      "choices" => [
        {
          "id"      => "aaa", # 随机字符串
          "text"    => "一条",
        },
        {
          "id"      => "bbb",
          "text"    => "两条",
        },
        {
          "id"      => "ccc",
          "text"    => "三条",
        },
        {
          "id"      => "ddd",
          "text"    => "四条",
        },
        {
          "id"      => "eee",
          "text"    => "五条",
        }
      ],
      "corrects" => ["bbb","ccc","ddd","eee"]
    })
  end

  factory :mapping_question, class: QuestionBank::Question do
    kind "mapping"
    content "英文字母连线"
    level 1
    enabled true
    answer( {
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
    })
  end

  factory :fill_question, class: QuestionBank::Question do
    kind "fill"
    content "中国___, 英国___"
    level 1
    enabled true
    answer ["北京", "伦敦"]
  end

  factory :essay_question, class: QuestionBank::Question do
    kind "essay"
    content "论亲情"
    level 1
    enabled true
    answer "很关键"
  end

  factory :bool_question, class: QuestionBank::Question do
    kind :bool
    content "一加一等于二"
    enabled true
    level 1
    answer true
  end

end
