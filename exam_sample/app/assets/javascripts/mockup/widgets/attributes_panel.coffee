@AttributesPanel = React.createClass
  displayName: 'AttributesPanel'
  render: ->
    <div className='attributes-panel'>
    {
      for item, idx in @props.data
        <div key={idx} className='item'>
          <span className='name-label'>
            <i className="icon #{item.icon}" />
            <span className='name'>{item.name}</span>
          </span>
          <span className='value-label'>{item.value}</span>
        </div>
    }
    </div>