@ExerciseFaceCalPage = React.createClass
  is_valid_all: ->
    wrong = false
    for answer, index in @state.question.answer
      wrong = true if @state.answer_value[index] != answer

    !wrong

  is_valid: (index) ->
    wrong = true
    if @state.question.answer[index] == @state.answer_value[index]
      wrong  = false

    !wrong

  valid: (index)->
    wrongs = @state.wrongs
    wrongs[index] = !@is_valid(index)
    @setState
      wrong: wrongs

  answer: (index) ->
    (evt) =>
      console.log 'answer'
      @state.answer_value[index] = evt.target.value
      @valid(index)

  render_question: (question)->
    <table className="ui striped table celled">
      <thead>
        <tr>
          <th>序号</th>
          <th>起止页</th>
          <th>行数</th>
          <th>答案</th>
          <th>序号</th>
          <th>起止页</th>
          <th>行数</th>
          <th>答案</th>
        </tr>
      </thead>
      <tbody>
        {
          for index in [0..((question.content.length/2) + (question.content.length % 2))]
            if question.content[index + question.content.length/2]
              <tr key={index}>
                <td>{index + 1}</td>
                <td>{question.content[index][0]}</td>
                <td>{question.content[index][1]}</td>
                <td>
                  <div className="ui fluid input #{if @state.wrongs[index] then 'error' else ''}" key={index}>
                    <input type="text" onBlur={@answer(index)} ref="input" defaultValue={@state.answer_value[index]} />
                  </div>
                </td>
                <td>{index + question.content.length / 2 + 1}</td>
                <td>{question.content[index + question.content.length / 2][0]}</td>
                <td>{question.content[index + question.content.length / 2][1]}</td>
                <td>
                  <div className="ui fluid input #{if @state.wrongs[index + question.content.length / 2] then 'error' else ''}">
                    <input type="text" onBlur={@answer(index + question.content.length / 2)} defaultValue={@state.answer_value[index + question.content.length / 2]} />
                  </div>
                </td>
              </tr>
        }
      </tbody>
    </table>

  next: (answer)->
    right = @state.question_right
    right += 1 if @is_valid_all()
    question = @props.data.questions[@state.question_index + 1]
    @setState
      question_index: @state.question_index + 1
      question: question
      question_right: right
      wrongs: (false for i in question.content)
      answer_value: []

    jQuery(".ui.fluid.input.error").removeClass "error"
    jQuery(".ui.fluid.input input").map ->
      this.value = ""


  getInitialState: ->
    question = @props.data.questions[0]
    question_index: 0
    question_right: 0
    question: question
    wrongs: (false for i in question.content)
    answer_value: ("" for i in question.content)

  render: ->
    params =
      data: @props.data
      question: @state.question
      next: @next
      question_index: @state.question_index
      question_right: @state.question_right
      is_start: true
      render_question: @render_question
      page: @

    if @state.question.kind != "essay"
      params['render_question'] = @render_question

    <ExerciseBase {...params}>

    </ExerciseBase>

