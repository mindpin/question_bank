@SiteSearch = React.createClass
  getInitialState: ->
    query: @props.query || ''

  render: ->
    <div className='ui icon input'>
      <input type='text' placeholder='搜索课程…' value={@state.query} onChange={@change} onKeyPress={@enter_submit} />
      <i className='search link icon' onClick={@search}></i>
    </div>

  change: (evt)->
    @setState query: evt.target.value

  search: ->
    window.location.href = "/search/#{@state.query}"

  enter_submit: (evt)->
    if evt.which is 13
      @search()