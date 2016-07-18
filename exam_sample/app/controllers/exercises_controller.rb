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
      when "multi_cal"
        @component_data[:questions] = [
          {"content":[[360458.78,17061.12,3972.32,67.29,849.44,26462.58],[756775.22,683.26,126706.75,31.49,-30235.86,13655.61],[1223.72,890.76,456.35,-92271.95,4794.95,384.8],[-2957.97,895082.93,668.45,98967.75,99294.76,981691.29],[1637.02,16511.48,320960.74,57849.08,991.2,15.68],[4315.74,206.28,320153.72,4316.46,8551.27,845352.62],[7343.62,739279.81,51087.77,53397.82,158.98,579.8],[673683.43,-5190.71,552.5,436.84,420.47,3548.34],[4387.98,424639.44,264.49,902597.97,198876.18,-95654.15],[412250.41,88054.08,189.62,5162.14,98661.96,58780.47]],"answer":{"0,sum":408871.53,"1,sum":867616.47,"2,sum":-84521.37,"3,sum":2072747.21,"4,sum":397965.2,"5,sum":1182896.09,"6,sum":851847.8,"7,sum":673450.87,"8,sum":1435111.91,"9,sum":663098.68,"sum,0":2219117.95,"sum,1":2177218.45,"sum,2":825012.71,"sum,3":1030554.89,"sum,4":382363.35,"sum,5":1834817.04,"sum":8469084.39}},
          {"content":[[360458.78,17061.12,3972.32,67.29,849.44,26462.58],[756775.22,683.26,126706.75,31.49,-30235.86,13655.61],[1223.72,890.76,456.35,-92271.95,4794.95,384.8],[-2957.97,895082.93,668.45,98967.75,99294.76,981691.29],[1637.02,16511.48,320960.74,57849.08,991.2,15.68],[4315.74,206.28,320153.72,4316.46,8551.27,845352.62],[7343.62,739279.81,51087.77,53397.82,158.98,579.8],[673683.43,-5190.71,552.5,436.84,420.47,3548.34],[4387.98,424639.44,264.49,902597.97,198876.18,-95654.15],[412250.41,88054.08,189.62,5162.14,98661.96,58780.47]],"answer":{"0,sum":408871.53,"1,sum":867616.47,"2,sum":-84521.37,"3,sum":2072747.21,"4,sum":397965.2,"5,sum":1182896.09,"6,sum":851847.8,"7,sum":673450.87,"8,sum":1435111.91,"9,sum":663098.68,"sum,0":2219117.95,"sum,1":2177218.45,"sum,2":825012.71,"sum,3":1030554.89,"sum,4":382363.35,"sum,5":1834817.04,"sum":8469084.39}}
        ]
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

