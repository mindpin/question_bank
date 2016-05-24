@ExerciseMultiCalPage = React.createClass
  is_valid_all: ->
    wrong = false
    for key, answer of @state.question.answer
      wrong = true if @state.answer_value[key] != answer.toString()

    !wrong

  is_valid: (key) ->
    console.log 'is_valid'
    wrong = true
    wrong  = false if @state.question.answer[key].toString() == @state.answer_value[key]
    !wrong

  valid: (key)->
    console.log 'valid'
    console.log key
    wrongs = @state.wrongs
    wrongs[key] = !@is_valid(key)
    @setState
      wrongs: wrongs

  answer: (key) ->
    (evt) =>
      console.log 'answer'
      console.log key
      values = @state.answer_value
      values[key] = evt.target.value
      @setState
        answer_value: values

      @valid(key)

  render_question: (question)->
    <table className="ui striped table celled">
      <thead>
        <tr>
          <th>序号</th>
          {
            for c, index in question.content[0]
              <th key={index}>{index + 1}</th>
          }
          <th>合计</th>
        </tr>
      </thead>
      <tbody>
        {
          for content, row in question.content
            <tr key={row}>
              <td>{row + 1}</td>
              {
                for c, col in content
                  <td key={col}>{c}</td>
              }
              <td>
                <div className="ui fluid input #{if @state.wrongs[row.toString() + ',sum'] then 'error' else ''}" key={row}>
                  <input type="text" onBlur={@answer("#{row},sum")} ref="input" />
                </div>
              </td>
            </tr>
        }
        <tr>
          <td>总计</td>
          {
            for content, col in question.content[0]
              <td key={col}>
                <div className="ui fluid input #{if @state.wrongs['sum,' + col.toString()] then 'error' else ''}" key={col}>
                  <input type="text" onBlur={@answer("sum,#{col}")} ref="input" defaultValue={@state.answer_value["sum,#{col}"]} />
                </div>
              </td>
          }
          <td>
            <div className="ui fluid input #{if @state.wrongs['sum'] then 'error' else ''}">
              <input type="text" onBlur={@answer("sum")} ref="input" defaultValue={@state.answer_value["sum"]} />
            </div>
          </td>
        </tr>
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
      wrongs: {}
      answer_value: {}

    jQuery(".ui.fluid.input.error").removeClass "error"
    jQuery(".ui.fluid.input input").map ->
      this.value = ""

  getInitialState: ->
    window.question = @props.data.questions[0]
    question_index: 0
    question_right: 0
    question: question
    wrongs: {}
    answer_value: {}

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


