class QuestionFillAnswerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    fill_answer = object.fill_answer

    if fill_answer.blank?
      return _build_blank_answer.html_safe
    end

    dom = ""
    fill_answer.each_with_index do |fill_answer_item, i|
      dom += _build_item(fill_answer_item, i)
    end
    dom += _build_add_button

    dom = <<-EOF
      <div class="option-key-field">
        #{dom}
      </div>
    EOF

    dom.html_safe
  end

  def _build_blank_answer
    <<-EOF
      <div class="answer hidden">
        <input name="question[fill_answer][]" class="string optional" type="text" id="question_fill_answer">
        <a class="btn btn-default delete " href="javascript:;" role="button">删除</a>
      </div>
      <a class="btn btn-default append " href="javascript:;" role="button">添加</a>
    EOF
  end

  def _build_item(fill_answer_item, index)
    <<-EOF
      <div class="answer">
        <input name="question[fill_answer][]" value="#{fill_answer_item}" class="string optional" type="text" id="question_fill_answer">
        <a class="btn btn-default delete " href="javascript:;" role="button">删除</a>
      </div>
    EOF
  end

  def _build_add_button
    <<-EOF
      <a class="btn btn-default append " href="javascript:;" role="button">添加</a>
    EOF
  end
end
