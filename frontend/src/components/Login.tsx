import React from 'react'
import classnames from 'classnames'
import startCase from 'lodash/capitalize'

import {
  Navigate,
  useLocation,
  useNavigate,
  useSearchParams,
} from 'react-router-dom'
import { Github as GithubIcon } from 'react-bootstrap-icons'

import Button from 'react-bootstrap/Button'
import Col from 'react-bootstrap/Col'
import Container from 'react-bootstrap/Container'
import Form from 'react-bootstrap/Form'
import ModalForm from './ModalForm'
import Row from 'react-bootstrap/Row'
import TextInput from './TextInput'
import Spinner from 'react-bootstrap/Spinner'

import {
  login,
  localLogin,
  getUrlInfo,
  getIsLoggedIn,
} from '../app/reducers/auth'
import { registerUser } from '../app/reducers/users'
import { useAppDispatch, useAppSelector } from '../app/hooks'

import request from '../app/request'

import './Login.scss'

interface LoginStateI {
  username: string
  password: string
}

interface SignupStateI extends LoginStateI {
  first_name: string
  last_name: string
  password_confirmation: string
}

interface ErrorStateI {
  login: Partial<Record<keyof LoginStateI, string>>
  signup: Partial<Record<keyof SignupStateI, string>>
}

const initialLoginState: LoginStateI = {
  username: '',
  password: '',
}

const initialSignupState: SignupStateI = {
  ...initialLoginState,
  first_name: '',
  last_name: '',
  password_confirmation: '',
}

const loginReducer = (state: LoginStateI, update: Partial<LoginStateI>) => ({
  ...state,
  ...update,
})
const signupReducer = (state: SignupStateI, update: Partial<SignupStateI>) => ({
  ...state,
  ...update,
})

const Login = () => {
  const [data, setData] = React.useState({ errorMessage: '', isLoading: false })
  const navigate = useNavigate()
  const dispatch = useAppDispatch()
  const location = useLocation()
  const [params] = useSearchParams()
  const code = params.get('code')
  const [showSignupModal, setShowSignupModal] = React.useState(false)
  const [errors, setErrors] = React.useState<ErrorStateI>({
    login: {},
    signup: {},
  })

  const [loginState, loginDispatch] = React.useReducer(
    loginReducer,
    initialLoginState
  )
  const [signupState, signupDispatch] = React.useReducer(
    signupReducer,
    initialSignupState
  )

  const isLoggedIn = useAppSelector(getIsLoggedIn)
  const { client_id, proxy_url, redirect_uri } = useAppSelector(getUrlInfo)

  React.useEffect(() => {
    // After requesting Github access, Github redirects back to your app with a code parameter

    if (!code) return
    if (!proxy_url) return

    const url = location.pathname

    // If Github API returns the code parameter
    const newUrl = url.split('?code=')
    navigate(newUrl[0])
    setData({ ...data, isLoading: true })

    const requestData = {
      provider: 'github',
      code,
    }

    request
      .post({ path: proxy_url, data: requestData })
      .then(({ user, headers }) => {
        dispatch(
          login({
            user,
            isLoggedIn: true,
            token: headers.authorization,
          })
        )
      })
      .catch(() => {
        setData({
          isLoading: false,
          errorMessage: 'Sorry! Login failed',
        })
      })
  }, [data])

  if (isLoggedIn) {
    return <Navigate to="/" />
  }

  const validateLogin = (field: keyof LoginStateI) => () => {
    const valid = loginState[field].length > 0

    const newErrors = { ...errors }

    newErrors.login[field] = valid
      ? undefined
      : `${startCase(field)} is required`

    setErrors(newErrors)
  }

  const validateSignup = (field: keyof SignupStateI) => () => {
    const lengthValid = signupState[field].length > 0

    const newErrors = { ...errors }

    newErrors.signup[field] = lengthValid
      ? undefined
      : `${startCase(field)} is required`

    switch (field) {
      case 'username': {
        if (
          lengthValid &&
          !/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(
            signupState[field]
          )
        ) {
          newErrors.signup[field] = `${startCase(
            field
          )} must be an email address`
        }
      }
    }

    setErrors(newErrors)
  }

  const handleLoginChange =
    (field: keyof LoginStateI) => (e: React.ChangeEvent<HTMLInputElement>) => {
      loginDispatch({ [field]: e.target.value })
    }

  const handleSignupChange =
    (field: keyof SignupStateI) => (e: React.ChangeEvent<HTMLInputElement>) => {
      signupDispatch({ [field]: e.target.value })
    }

  const handleLogin = () => {
    dispatch(localLogin({ data: { provider: 'local', ...loginState } }))
  }

  const handleSignup = () => {
    dispatch(registerUser(signupState))
  }

  const handleGithubLogin = () => {
    window.location.href = `https://github.com/login/oauth/authorize?scope=user&client_id=${client_id}&redirect_uri=${redirect_uri}`
  }

  return (
    <section>
      <ModalForm
        heading="Signup"
        visible={showSignupModal}
        onHide={() => setShowSignupModal(false)}
        onSubmit={handleSignup}
      >
        <TextInput
          label="First Name"
          onBlur={validateSignup('first_name')}
          onChange={handleSignupChange('first_name')}
          value={signupState.first_name}
          valid={!errors.signup.first_name}
          errorMessage={errors.signup.first_name}
        />
        <TextInput
          label="Last Name"
          onBlur={validateSignup('last_name')}
          onChange={handleSignupChange('last_name')}
          value={signupState.last_name}
          valid={!errors.signup.last_name}
          errorMessage={errors.signup.last_name}
        />
        <TextInput
          label="Email Address"
          onBlur={validateSignup('username')}
          onChange={handleSignupChange('username')}
          value={signupState.username}
          valid={!errors.signup.username}
          errorMessage={errors.signup.username}
        />
        <TextInput
          label="Password"
          onBlur={validateSignup('password')}
          onChange={handleSignupChange('password')}
          value={signupState.password}
          valid={!errors.signup.password}
          errorMessage={errors.signup.password}
        />
        <TextInput
          label="Password Confirmation"
          onBlur={validateSignup('password_confirmation')}
          onChange={handleSignupChange('password_confirmation')}
          value={signupState.password_confirmation}
          valid={!errors.signup.password_confirmation}
          errorMessage={errors.signup.password_confirmation}
        />
      </ModalForm>
      <Container>
        <Row>
          <Col md={{ span: 4, offset: 2 }}>
            <h1>Login</h1>
            <Form>
              <TextInput
                label="Username"
                onBlur={validateLogin('username')}
                onChange={handleLoginChange('username')}
                value={loginState.username}
                valid={!errors.login.username}
                errorMessage={errors.login.username}
              />
              <TextInput
                label="Password"
                onBlur={validateLogin('password')}
                onChange={handleLoginChange('password')}
                value={loginState.password}
                valid={!errors.login.password}
                errorMessage={errors.login.password}
              />
            </Form>
            <span>{data.errorMessage}</span>
            <div
              className={classnames('login-container', 'd-grid', 'gap-2', {
                loading: data.isLoading,
              })}
            >
              {data.isLoading ? (
                <Spinner animation="border" role="status" />
              ) : (
                <>
                  <Button onClick={handleLogin} size="sm">
                    Login
                  </Button>
                  <Button
                    onClick={handleGithubLogin}
                    variant="outline-secondary"
                    size="sm"
                  >
                    Login with Github <GithubIcon />
                  </Button>
                  <span>or</span>
                  <Button size="sm" onClick={() => setShowSignupModal(true)}>
                    Signup
                  </Button>
                </>
              )}
            </div>
          </Col>
        </Row>
      </Container>
    </section>
  )
}

export default Login
