@ExerciseChinesePage = React.createClass
  componentDidMount: ->
    $('.menu .item')
      .tab()

  render: ->
    <div className="ui segment">
      <div className="ui top attached tabular menu">
        <a className="item" href="/">科目列表</a>
        <a className="item active" data-tab="second">中文录入</a>
      </div>
      <div className="ui bottom attached tab segment active" data-tab="second">
        中文录入
      </div>
    </div>
