@ExerciseChinesePage = React.createClass
  SetIntervalMixin:
    componentWillMount: ->
      @intervals = []

    setInterval: ->
      @intervals.push setInterval.apply(null, arguments)

    componentWillUnmount: ->
      @intervals.map(clearInterval)

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

  valid: (evt)->
    if evt.target.value == @state.question.answer
      @setState
        wrong: false
    else
      @setState
        wrong: true

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

  tick_stop: ->
    clearInterval @interval if @interval
    @interval = null
    @setState
      play: false

  tick: ->
    @setState
      second: @state.second + 1

  mixins: [@SetIntervalMixin]

  getInitialState: ->
    play: false
    second: 0
    question_index: 0
    question_right: 0
    question_count: @props.data.questions.count
    question: @props.data.questions[0]
    wrong: false

  render: ->
    <div className="">
      <div className="ui top attached tabular menu">
        <a className="item" href="/">科目列表</a>
        <a className="item active" data-tab="second">中文录入</a>
      </div>
      <div className="ui bottom attached tab segment active" data-tab="second">
        <div className="ui grid">
          <div className="four wide column">
            <div className="ui segment">
              <h4 className="ui header">控制</h4>
              <p>
                {
                  if @state.play
                    <a href="javascript:;" className="ui button icon teal" onClick={@toggle_play}>
                      <i className="pause icon"></i>
                    </a>
                  else
                    <a href="javascript:;" className="ui button icon teal" onClick={@toggle_play}>
                      <i className="play icon"></i>
                    </a>
                }
                <a href="javascript:;" className="ui button icon teal" onClick={@refresh_page}>
                  <i className="refresh icon"></i>
                </a>
              </p>
            </div>

            <div className="ui segment">
              <h4 className="ui header">用时</h4>
              <p>
                {@outputSeconds()}
              </p>
            </div>

            <div className="ui segment">
              <h4 className="ui header">正确率</h4>
              <div className="ui progress teal">
                {
                  if @state.question_count > 0
                    percent = ( 100.0 * @state.question_right / @state.question_count)
                    str = "#{percent}%"
                  else
                    percent = 0
                    str = "未开始"
                  <div className="bar" style={{"transitionDuration": "300ms", "width": "#{percent}%"}}>
                    <div className="progress">{str}</div>
                  </div>
                }
              </div>
            </div>
          </div>
          <div className="twelve wide column">
            <div className="ui segment">
              <div>
                {
                  @state.question.content
                }
              </div>

              <br />

              <div className="ui fluid input #{if @state.wrong then 'error' else ''}">
                <input type="text" name="" id="" placeholder="输入后自动开始计时" onKeyUp={@tick_start} onBlur={@valid} />
              </div>

              <br />

              <div className="ui button big teal right floated">
                下一题
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
