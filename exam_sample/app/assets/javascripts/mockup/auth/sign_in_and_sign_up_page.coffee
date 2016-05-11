@AuthSignInPage = React.createClass
  render: ->
    <div className='sign-in-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic centered grid'>
          <div className='five wide column'>
            <SignHead data={@props.data} is_sign_up={false} />
            <SignInForm submit_url={@props.data.submit_url} />
          </div>
        </div>
      </div>
    </div>

@AuthSignUpPage = React.createClass
  render: ->
    <div className='sign-in-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic centered grid'>
          <div className='five wide column'>
            <SignHead data={@props.data} is_sign_up={true} />
            <SignUpForm submit_url={@props.data.submit_url} />
          </div>
        </div>
      </div>
    </div>


@AuthManagerSignInPage = React.createClass
  render: ->
    common_button_style =
      position: 'absolute'
      top: '1rem'
      left: '1rem'

    common_sign_in_url = @props.data.common_sign_in_url

    common_button = 
      <a className='ui basic button' style={common_button_style} href={common_sign_in_url}>普通登录</a>

    <div className='auth-bank-sign-in-page'>
      {common_button}

      <div className='ui container'>
        <div className='ui grid'>
          <div className='four wide column'>
          </div>
          <div className='eight wide column'>
            <div className='ui segment'>
              <div className='head'>
                <i className='icon sign in' />
                <span className='sign-in link'>后台登录</span>
              </div>
              <SignInForm submit_url={@props.data.submit_url} jump={@props.data.manager_home_url} />
            </div>
          </div>
        </div>
      </div>
    </div>


SignHead = React.createClass
  render: ->
    sign_in_url = @props.data.sign_in_url
    sign_up_url = @props.data.sign_up_url

    if @props.is_sign_up
      <div className='head'>
        <a className='sign-in link' href={sign_in_url}>登录</a>
        <a className='sign-up link active' href={sign_up_url}>注册</a>
      </div>
    else
      <div className='head'>
        <a className='sign-in link active' href={sign_in_url}>登录</a>
        <a className='sign-up link' href={sign_up_url}>注册</a>
      </div>