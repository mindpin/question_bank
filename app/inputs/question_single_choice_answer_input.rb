class QuestionSingleChoiceAnswerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @choice_answer_indexs = object.choice_answer_indexs
    choices = object.choices

    choices = ["",""] if choices.blank?
    choices = ["",""] if choices == [""]

    dom = ""
    dom += _build_radio_hidden
    choices.each_with_index do |choice, i|
      dom += _build_radio(choice, i)
    end
    dom += _build_add_button

    dom.html_safe
  end

  def _build_radio_hidden
     <<-EOF
      <div class="radio hidden">
        <label for="question_choices">
          <input type="radio" value=""  name="question[choice_answer_indexs][]" id="question_choice_answer_indexs_0" />
          <input name="question[choices][]" type="text" value="" id="question_choices" />
          <a class='btn btn-default delete-choice'>删除选项</a>
        </label>
      </div>
    EOF
  end

  def _build_radio(choice, i)
    checked = ""
    checked = 'checked="checked"' if @choice_answer_indexs.include?(i)
    <<-EOF
      <div class="radio">
        <label for="question_choices">
          <input type="radio" value="#{i}" #{checked} name="question[choice_answer_indexs][]" id="question_choice_answer_indexs_#{i+1}" />
          <input name="question[choices][]" type="text" value="#{choice}" id="question_choices" />
          <a class='btn btn-default delete-choice'>删除选项</a>
        </label>
      </div>
    EOF
  end

  def _build_add_button
    <<-EOF
      <a class="btn btn-default add-choice">添加选项</a>
    EOF
  end
end
