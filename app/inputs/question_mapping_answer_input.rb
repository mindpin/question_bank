class QuestionMappingAnswerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    mapping_answer = object.mapping_answer

    mapping_answer = [["",""],["",""]] if mapping_answer.blank?
    mapping_answer << ["",""] if mapping_answer.count == 1

    dom = ""
    mapping_answer.each_with_index do |mapping_answer_item, i|
      dom += _build_item(mapping_answer_item, i)
    end
    dom += _build_add_button

    dom = <<-EOF
      <div class="option-key-field">
        #{dom}
      </div>
    EOF

    dom.html_safe
  end

  def _build_item(mapping_answer_item, index)
    <<-EOF
      <div class="item ">
        <input name="question[mapping_answer][#{index}][]" class="string optional" type="text" value="#{mapping_answer_item[0]}" id="question_mapping_answer">
        <input name="question[mapping_answer][#{index}][]" class="string optional" type="text" value="#{mapping_answer_item[1]}" id="question_mapping_answer">
        <a class="btn btn-success delete" href="javascript:;" role="button" ">删除连线</a>
      </div>
    EOF
  end

  def _build_add_button
    <<-EOF
      <div class="add-items">
        <a class="btn btn-success append" href="javascript:;" role="button">添加一组选项</a>
        <span>请将正确答案连接</span>
      </div>
    EOF
  end
end
