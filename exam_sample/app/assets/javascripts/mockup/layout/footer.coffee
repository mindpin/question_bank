@LayoutFooter = React.createClass
  render: ->
    <div className='layout-page-footer'>
      <div className='ui container'>
        <div className='ui segment basic grid'>
          <div className='twelve wide column'>
            <div className='links'>
            {
              for name, url of @props.data.links
                <a key={name} className='link' href={url}>{name}</a>
            }
            </div>
            <div className='description'>{@props.data.desc}</div>
          </div>
          <div className='three wide column right floated'>
            <div className='logo'>
              <div className='lbg' style={'backgroundImage': "url(#{@props.data.logo})"} />
            </div>
          </div>
        </div>
      </div>
    </div>