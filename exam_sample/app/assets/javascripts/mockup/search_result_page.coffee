@SearchResultPage = React.createClass
  render: ->
    <div>
      <div className='ui container'>
        <div className='ui segment basic'>
          <SiteSearch query={@props.data.query} />

          <h3 className='ui header' style={marginBottom: '3rem'}>
            搜索
            <span style={color: 'red'}>{@props.data.query}</span>
            的结果：
          </h3>

          <div className='wares ui cards'>
          {
            for ware in @props.data.wares
              <FinanceTellerWareCard key={ware.id} data={ware} />
          }
          </div>
        </div>
      </div>
    </div>