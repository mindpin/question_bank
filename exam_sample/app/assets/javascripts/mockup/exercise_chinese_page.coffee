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

  toggle_play: ->
    if @state.play
      @tick_stop()
    else
      @tick_start()

    @setState
      play: !@state.play

  tick_start: ->
    @interval = setInterval(@tick, 1000)

  tick_stop: ->
    console.log @interval
    clearInterval @interval if @interval
    @interval = null

  tick: ->
    @setState
      second: @state.second + 1

  mixins: [@SetIntervalMixin]

  getInitialState: ->
    play: true
    second: 0

  componentWillMount: ->
    @tick_start()

  render: ->
    <div className="">
      <div className="ui top attached tabular menu">
        <a className="item" href="/">科目列表</a>
        <a className="item active" data-tab="second">中文录入</a>
      </div>
      <div className="ui bottom attached tab segment active" data-tab="second">
        <div className="ui grid">
          <div className="three wide column">
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
                <a href="#" className="ui button icon teal">
                  <i className="reply icon"></i>
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
                <div className="bar" style={{"transitionDuration": "300ms", "width": "80%"}}>
                  <div className="progress">80%</div>
                </div>
              </div>
            </div>
          </div>
          <div className="three wide column">
            中文录入
          </div>
        </div>
      </div>
    </div>
