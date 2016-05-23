class ExercisesController < ApplicationController

  def index
    if DemoQuestion.subjects.include?(params[:subject])
      @page_name = "exercise_#{params[:subject]}"
      subject = params[:subject]
      @component_data = {
        subject: subject
      }
      case subject
      when 'number'
        @component_data[:questions] = 
          (1..10).map do |i|
            num = rand(56887746371819585459)
            {
              content: num.to_s,
              answer: num.to_s,
              kind: "qanda"
            }
          end
      when 'address'
        str = "南岗区人和地下购物中心"
        @component_data[:questions] =
          (1..10).map do |i|
            {
              content: str,
              answer: str,
              kind: "qanda"
            }
          end
      when 'code'
        @component_data[:questions] =
          (1..10).map do |i|
            {
              content: "借据登记薄打印",
              answer: i.to_s * 4,
              kind: "qanda"
            }
          end
      when 'summons'
        format = "%0.2f"
        @component_data[:questions] =
          (1..10).map do |i|
            num = format % (rand * 103326588836)
            {
              content: num,
              answer: num.to_s,
              kind: "qanda"
            }
          end
      when "face_cal"
        @component_data[:questions] =
          (1..10).map do |i|
            {
              content: (1..20).map do |j|
                [
                  "#{rand(20) + 10}-#{rand(30) + 30}",
                  rand(5) + 1
                ]
              end,
              answer: (1..20).map do |j|
                j.to_s
              end,
              kind: "face_cal"
            }
          end
      when 'theory'
        @component_data[:questions] =
          [
            {
              content: "作为一名银行的客户经理或一线柜员，必须树立良好的营销意识，具备沟通和销售的基本技能，掌握得当的营销技巧和表达艺术。",
              answer: true,
              kind: "bool"
            },
            {
              kind: "single_choice",
              content: "１、销售流程的各个环节包括：　　　　、有效拉近与客户距离、确认客户需求、成功说服客户、异议处理以及最终提供满意方案等",
              answer: [
                ["如何寻找客户", true],
                ["了解自己银行的产品", false],
                ["加强服务意识", false],
                ["制定销售计划", false]
              ],
            },
            {
              kind: "multi_choice",
              content: "判断客户购买欲望的大小，包括以下　　　　检查要点。",
              answer: [
                ["对产品购入的关心程度", true],
                ["是否能符合各项需求 ", true],
                ["对产品是否信赖", false],
                ["对本银行是否有良好的印象", false]
              ],
            },
            #{
              #kind: "mapping",
              #content: "连接首都",
              #answer: [
                #["日本","东京"],
                #["法国","巴黎"],
                #["俄罗斯","莫斯科"]
              #],
            #},
            {
              kind: "essay",
              level: 1,
              content: "培养成长型客户的技巧中，如何扩大客户选择的自由？",
              answer: "本银行的产品选择,同业之间的选择,客户服务人员的选择",
            },
            {
              kind: "fill",
              level: 1,
              content: "____,其徐如林，____,不动如山",
              answer: [
                "其疾如风",
                "侵略如火"
              ],
            },
          ]
      else
      end


      render "mockup/page"
    else
      redirect_to root_path
    end
  end

end

