@CourseWaresList = React.createClass
  getInitialState: ->
    active_ware_id: @props.active_ware_id

  render: ->
    style = @props.style || 'detail'

    <div className="course-wares-list style-#{style}">
    {
      for chapter, idx in @props.data.chapters
        <CourseWaresList.Chapter key={idx} data={chapter} root={@} style={style} />
    }
    </div>

  statics:
    Chapter: React.createClass
      displayName: 'Chapter'
      render: ->
        <div className='chapter'>
          <div className='chname'>
            <div className='pipe' />
            <div className='cwicon' />
            <span className='name'>{@props.data.name}</span>
          </div>

        {
          for ware, idx in @props.data.wares
            icon = 
              switch ware.kind
                when 'video'
                  <i className='kindicon icon play' />
                else
                  <i className='kindicon icon file text outline' />

            tail =
              switch ware.kind
                when 'video'
                  <span>
                    <i className='icon wait' />
                    {ware.time}
                  </span>
                else
                  <span></span>

            klass = new ClassName
              'ware': true
              "learned-#{ware.learned}": true
              'active': @props.root.state.active_ware_id is ware.id

            <a key={idx} className={klass} href='javascript:;' onClick={@do_click(ware)}>
              <span className='tail'>{tail}</span>
              <div className='pipe'></div>
              <div className='cwicon'>
              </div>
              {icon}
              <span className='name'>{ware.name}</span>
            </a>
        }
        </div>

      do_click: (ware)->
        switch @props.style
          when 'narrow'
            ->
              Turbolinks.visit ware.url
          when 'detail'
            ->
              Turbolinks.visit ware.url