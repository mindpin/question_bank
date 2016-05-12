@FinanceCourseSelectWizard = React.createClass
  getInitialState: ->
    posts: @props.posts
    step: 0

    selected_post: null
    selected_level: null

    result_wares: @props.result_wares

  render: ->
    <div className='finance-course-select-wizard'>
      <div className='wizard-header'>
        <div className='title'>学习内容选择向导：</div>
        <div className='step'>
          {
            if @state.step > 0
              <span><i className='icon checkmark' /> 选择岗位</span>
            else
              <span><i>1</i> 选择岗位</span>
          }
        </div>
        <div className='step'>
          {
            if @state.step > 1
              <span><i className='icon checkmark' /> 选择级别</span>
            else
              <span><i>2</i> 选择级别</span>
          }
        </div>
        <div className='step'>
          {
            if @state.step > 2
              <span><i className='icon checkmark' /> 获取内容</span>
            else
              <span><i>3</i> 获取内容</span>
          }
        </div>

        <div className='search'>
          <SiteSearch />
        </div>
      </div>

    {
      switch @state.step
        when 0
          <div key='s0' ref='current_step'>
            <h3 className='ui header'>请选择一个岗位：</h3>
            <div className='posts'>
            {
              for post in @state.posts
                <FinanceCourseSelectWizard.Post key={post.id} data={post} wizard={@}/>
            }
            </div>
          </div>
        when 1
          <div key='s1' ref='current_step'>
            <h3 className='ui header'>
              <a href='javascript:;' className='back' onClick={@back}><i className='icon left arrow circle' /></a>

              岗位：{@state.selected_post?.name}，
              请选择一个级别：
            </h3>
            <div className='levels ui list'>
            {
              for level in @state.selected_post.linked_levels
                <FinanceCourseSelectWizard.Level key={level.id} data={level} wizard={@}/>
            }
            </div>
          </div>
        when 2
          <div key='s2' ref='current_step'>
            <h3 className='ui header'>
              <a href='javascript:;' className='back' onClick={@back}><i className='icon left arrow circle' /></a>

              岗位：{@state.selected_post?.name}，
              级别：{@state.selected_level?.name}，
              可学习以下业务操作：
            </h3>
            <div className='wares ui cards'>
            {
              for ware in @state.result_wares
                <FinanceTellerWareCard key={ware.id} data={ware} />
            }
            </div>
          </div>
    }
    </div>

  select_post: (post)->
    jQuery React.findDOMNode @refs.current_step
      .fadeOut 200, =>
        @setState
          selected_post: post
          step: 1

  selected_level: (level)->
    jQuery React.findDOMNode @refs.current_step
      .fadeOut 200, =>
        @setState
          selected_level: level
          step: 2

  back: ->
    jQuery React.findDOMNode @refs.current_step
      .fadeOut 200, =>
        @setState
          step: @state.step - 1

  statics:
    Post: React.createClass
      render: ->
        post = @props.data

        <a className='post' href='javascript:;' onClick={@select(post)}>
          <span className='number'>{post.number}</span>
          <span className='name'>{post.name}</span>
        </a>

      select: (post)->
        =>
          @props.wizard.select_post(post)

    Level: React.createClass
      render: ->
        level = @props.data
        <div className='item'>
        <a className='level' href='javascript:;' onClick={@select(level)}>
          <span className='number'>{level.number}</span>
          <i className='icon chevron right' />
          <span className='name'>{level.name}</span>
        </a>
        </div>

      select: (level)->
        =>
          @props.wizard.selected_level(level)