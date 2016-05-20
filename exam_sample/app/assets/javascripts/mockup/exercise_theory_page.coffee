@ExerciseTheoryPage = React.createClass
  is_valid: () ->
    wrong = true
    switch @state.question.kind
      when "qanda"
        wrong = false if @answer_value and @state.question.answer == @answer_value
      when "bool"
        wrong = false if @answer_value and @state.question.answer.toString() == @answer_value
      when "single_choice"
        wrong = false if @answer_value == "true"
      when "multi_choice"
        if @answer_value and @answer_value.length > 0
          wrong  = false
          for arr, index in @state.question.answer
            wrong = true if arr[1] == !@answer_value[index]
      when "essay"
        wrong = false if @answer_value and @state.question.answer == @answer_value
      when "fill"
        if @answer_value and @answer_value.length > 0
          wrong  = false
          for val, index in @state.question.answer
            wrong = true if val != @answer_value[index]

    !wrong

  valid: ()->
    @setState
      wrong: !@is_valid()

  answer: (index) ->
    (evt) =>
      console.log 'answer'
      console.log index
      if index != undefined
        console.log evt.target
        switch @state.question.kind
          when "multi_choice"
            console.log evt.target.checked
            @answer_value ||= []
            @answer_value[index] = evt.target.checked
          when "fill"
            console.log evt.target.value
            @answer_value ||= []
            @answer_value[index] = evt.target.value
      else
        @answer_value = evt.target.value
      @valid()

  render_question: (question)->
    switch question.kind
      when "bool"
        <div className="ui form">
          <div>
            {
              question.content
            }
          </div>

          <br />

          <div className="fields inline #{if @state.wrong then 'error' else ''}">
            <div className="field">
              <div className="ui radio">
                <input type="radio" name="result" className="hidden" value="true" onChange={@answer()} />
                <label>对</label>
              </div>
            </div>
            <div className="field">
              <div className="ui radio">
                <input type="radio" name="result" className="hidden" value="false" onChange={@answer()} />
                <label>错</label>
              </div>
            </div>
          </div>
        </div>
      when "single_choice"
        <div className="ui form">
          <div>
            {
              question.content
            }
          </div>

          <br />

          <div className="fields #{if @state.wrong then 'error' else ''}">
            {
              question.answer.map (arr, index)=>
                <div className="field" key={arr[0]}>
                  <div className="ui radio">
                    <input type="radio" name="result" className="hidden" value={arr[1]} onChange={@answer()} />
                    <label>{arr[0]}</label>
                  </div>
                </div>
            }
          </div>
        </div>
      when "multi_choice"
        <div className="ui form">
          <div>
            {
              question.content
            }
          </div>

          <br />

          <div className="field #{if @state.wrong then 'error' else ''}">
            {
              question.answer.map (arr, index)=>
                <label key={arr[0]}>
                  <input type="checkbox" name="result" value={arr[1]} onChange={@answer(index)} />
                  <label>{arr[0]}</label>
                </label>
            }
          </div>
        </div>
      #when "mapping"
      when "essay"
        <div>
          <p>
            {question.content}
          </p>

          <br />

          <div className="ui fluid input #{if @state.wrong then 'error' else ''}">
            <input type="text" name="" id="" placeholder="输入后自动开始计时" onBlur={@answer()} ref="input" />
          </div>
        </div>
      when "fill"
        <div>
          <p>
            {question.content}
          </p>

          <br />

          {
            for answer, index in question.answer
              <div className="ui fluid input #{if @state.wrong then 'error' else ''}" key={index}>
                <input type="text" name="" id="" placeholder="填写第#{index + 1}空答案" onBlur={@answer(index)} ref="input" />
              </div>
          }
        </div>
      else
        <div className="ui segment warning">
          暂不支持此种题型
        </div>

  next: (answer)->
    right = @state.question_right
    console.log @is_valid()
    right += 1 if @is_valid()
    @answer_value = null
    @setState
      question_index: @state.question_index + 1
      question: @props.data.questions[@state.question_index + 1]
      question_right: right
      wrong: false

  getInitialState: ->
    question_index: 0
    question_right: 0
    question: @props.data.questions[0]

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
      wrong: false

    if @state.question.kind != "essay"
      params['render_question'] = @render_question

    <ExerciseBase {...params}>

    </ExerciseBase>
