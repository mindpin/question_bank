@ExerciseChinesePage = React.createClass
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
                <a href="#" className="ui button icon teal">
                  <i className="pause icon"></i>
                </a>
                <a href="#" className="ui button icon teal">
                  <i className="reply icon"></i>
                </a>
              </p>
            </div>

            <div className="ui segment">
              <h4 className="ui header">用时</h4>
              <p>
                <span>00：01：38</span>
              </p>
            </div>

            <div className="ui segment">
              <h4 className="ui header">正确率</h4>
              <div className="ui progress teal">
                <div className="bar" style={{"transition-duration": "300ms", "width": "80%"}}>
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
