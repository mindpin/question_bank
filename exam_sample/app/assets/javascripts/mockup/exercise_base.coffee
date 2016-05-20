#SetIntervalMixin =
  #componentWillMount: ->
    #@intervals = []

  #setInterval: ->
    #@intervals.push setInterval.apply(null, arguments)

  #componentWillUnmount: ->
    #@intervals.map(clearInterval)

@ExerciseBase = React.createClass
  outputSeconds: ->
    @getFormattedTime @state.second

  getFormattedTime: (totalSeconds)->
    seconds = parseInt(totalSeconds % 60, 10)
    minutes = parseInt(totalSeconds / 60, 10) % 60
    hours = parseInt(totalSeconds / 3600, 10)
    seconds = '0' + seconds if seconds < 10
    minutes = '0' + minutes if minutes < 10
    hours = '0' + hours if hours < 10

    hours + ':' + minutes + ':' + seconds

  getRightPercentParams: ->
    if @props.question_index > 0
      percent = ( 100.0 * @props.question_right / (@props.question_index)).toFixed(0)
      percent: percent
      str: "#{percent}%"
    else
      percent: 0
      str: "未开始"

  next: ->
    answer = @answer_value
    if answer == "true" or answer == "false"
      answer = true if answer == "true"
      answer = false if answer == "false"
      jQuery('.ui.radio').checkbox('uncheck')

    @setState
      wrong: false
    @answer_value = null
    @refs.input.value = "" if @refs.input

    @props.next(answer)

  valid: ()->
    wrong = true
    console.log @props.question.kind
    console.log @answer_value
    switch @props.question.kind
      when "qanda"
        wrong = false if @answer_value and @props.question.answer == @answer_value
      when "bool"
        wrong = false if @answer_value and @props.question.answer.toString() == @answer_value
      when "single_choice"
        wrong = false if @answer_value == "true"
      when "multi_choice"
        if @answer_value.length > 0
          wrong  = false
          for arr, index in @props.question.answer
            wrong = true if arr[1] == !@answer_value[index]

    console.log wrong
    @setState
      wrong: wrong

  answer: (index) ->
    (evt) =>
      console.log 'answer'
      console.log index
      if index != undefined
        console.log evt.target
        console.log evt.target.checked
        @answer_value ||= []
        @answer_value[index] = evt.target.checked
      else
        @answer_value = evt.target.value
      @valid()
    #switch evt.target.type
      #when "radio"
        #if evt.target.value == @props.question.answer.toString()
          #@setState
            #wrong: false
        #else
          #@setState
            #wrong: true
      #when "text"
        #if evt.target.value == @props.question.answer
          #@setState
            #wrong: false
        #else
          #@setState
            #wrong: true

  refresh_page: ->
    window.location.reload()

  toggle_play: ->
    if @state.play
      @tick_stop()
    else
      @tick_start()

  tick_start: ->
    unless @interval
      @interval = setInterval(@tick, 1000)
      @setState
        play: true
        is_start: true

  tick_stop: ->
    clearInterval @interval if @interval
    @interval = null
    @setState
      play: false

  tick: ->
    @setState
      second: @state.second + 1

  #mixins: [SetIntervalMixin]

  componentDidMount: ->
    @tick_start() if @props.is_start

  componentWillUnmount: ->
    clearInterval @interval if @interval

  getInitialState: ->
    @question_count = @props.data.questions.length
    is_start: @props.is_start || false
    play: @props.is_start || false
    second: 0
    wrong: @props.wrong || false

  render: ->
    <div className="">
      {
        if @state.is_start and !@state.play
          <div className="ui page dimmer transition visible active inverted pause" onClick={@toggle_play}>

            <div className="content">
              <div className="center">
                <h2 className="ui icon header teal">
                  <i className="play icon"></i>
                </h2>
                <div className="sub header">
                  <div className="ui four column centered grid">

                    <div className="column">
                      <ExerciseBase.TimeCost time={@outputSeconds()} />
                    </div>

                    <div className="column">
                      <ExerciseBase.RightPercent {...@getRightPercentParams()} />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
      }
      <div className="ui top attached tabular menu">
        <a className="item" href="/">科目列表</a>
        <a className="item active" data-tab="second">中文录入</a>
      </div>
      <div className="ui bottom attached tab segment active" data-tab="second">
        <div className="ui grid">
          <div className="four wide column">
            <ExerciseBase.Controller play={@state.play} toggle_play={@toggle_play} />

            <ExerciseBase.TimeCost time={@outputSeconds()} />

            <ExerciseBase.RightPercent {...@getRightPercentParams()} />

          </div>
          <div className="twelve wide column">
            {
              if @props.render_question
                @props.render_question(@props.question)
              else
                if @props.label
                  <div className="ui grid">
                    <div className="three wide column">
                    </div>
                    <div className="thirteen wide column">
                      {@props.children}

                    </div>
                    <div className="three wide column right aligned base-label">
                      {@props.label}：
                    </div>
                    <div className="thirteen wide column">
                      <div className="ui fluid input #{if @state.wrong then 'error' else ''}">
                        <input type="text" name="" id="" placeholder="输入后自动开始计时" onKeyUp={@tick_start} onBlur={@answer()} ref="input" />
                      </div>
                    </div>
                  </div>
                else
                  <div>
                    {@props.children}

                    <br />

                    <div className="ui fluid input #{if @state.wrong then 'error' else ''}">
                      <input type="text" name="" id="" placeholder="输入后自动开始计时" onKeyUp={@tick_start} onBlur={@answer()} ref="input" />
                    </div>
                  </div>
            }
            <br />
            {
              if @props.question_index + 1 == @question_count
                <div className="ui button big green right floated">
                  结束
                </div>
              else
                <div className="ui button big teal right floated" onClick={@next}>
                  下一题
                </div>
            }
          </div>
        </div>
      </div>
    </div>

  statics:
    Controller: React.createClass
      render: ->
        <div className="ui segment panel">
          <h4 className="ui header">控制</h4>
          <p>
            {
              if @props.play
                <a href="javascript:;" className="ui button icon teal" onClick={@props.toggle_play}>
                  <i className="pause icon"></i>
                </a>
              else
                <a href="javascript:;" className="ui button icon teal" onClick={@props.toggle_play}>
                  <i className="play icon"></i>
                </a>
            }
            <a href="javascript:;" className="ui button icon teal" onClick={@refresh_page}>
              <i className="refresh icon"></i>
            </a>
          </p>
        </div>

    TimeCost: React.createClass
      render: ->
        <div className="ui segment panel">
          <h4 className="ui header">用时</h4>
          <p>
            {@props.time}
          </p>
        </div>

    RightPercent: React.createClass
      render: ->
        <div className="ui segment panel">
          <h4 className="ui header">正确率</h4>
          <div className="ui progress teal">
            <div className="bar" style={{"transitionDuration": "300ms", "width": "#{@props.percent}%"}}>
              <div className="progress">{@props.str}</div>
            </div>
          </div>
        </div>

