import {
  createAsyncThunk,
  createEntityAdapter,
  createSlice,
} from '@reduxjs/toolkit'
import Cookies from 'js-cookie'

import pick from 'lodash/pick'

import request, { API_URL, API_PORT } from '../request'

import type { RootState } from '../store'
import type { User } from '../types'
import { requestStatus } from '../types'

const AUTH_API = `${[API_URL, API_PORT].join(':')}/api/auth`

interface AuthI {
  isLoggedIn: boolean
  user: Record<string, string>
  client_id: string
  redirect_uri: string
  proxy_url: string
}

interface UserResponseI {
  user: User
}

interface ProxyRequestI {
  data: { provider: 'github'; code: string }
  proxy_url: string
}

interface LocalLoginRequestI {
  data: { provider: 'local'; username: string; password: string }
}

const authAdapter = createEntityAdapter<AuthI>()

const getUserFromLocalStorage = () => {
  const localStorageUser = localStorage.getItem('user')

  if (!localStorageUser) return null

  return JSON.parse(localStorageUser)
}

export const doGithubLogin = createAsyncThunk(
  'auth/proxy',
  async ({ proxy_url: path, data }: ProxyRequestI): Promise<UserResponseI> => {
    return await request.post<UserResponseI>({ path, data })
  }
)

export const localLogin = createAsyncThunk(
  'auth/localLogin',
  async ({ data }: LocalLoginRequestI): Promise<UserResponseI> => {
    return await request.post<UserResponseI>({ path: AUTH_API, data })
  }
)

const initialState = authAdapter.getInitialState({
  isLoggedIn: !!localStorage.getItem('isloggedin'),
  user: getUserFromLocalStorage(),
  client_id: process.env.REACT_APP_CLIENT_ID as string,
  redirect_uri: process.env.REACT_APP_REDIRECT_URI as string,
  token: Cookies.get('jwt_token'),
  proxy_url: `${
    process.env.REACT_APP_PROXY_URL || [API_URL, API_PORT].join(':')
  }/api/auth`,
})

const handleLoginSuccess = (state: any, action: any) => {
  localStorage.setItem('user', JSON.stringify(action.payload.user))
  Cookies.set('jwt_token', action.payload.token)

  return {
    ...state,
    isLoggedIn: !!action.payload.isLoggedIn,
    user: action.payload.user,
  }
}

export const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    login(state, action: any) {
      return handleLoginSuccess(state, action)
    },
    logout(state) {
      localStorage.clear()

      return {
        ...state,
        isLoggedIn: false,
        user: null,
      }
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(localLogin.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(localLogin.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        handleLoginSuccess(state, action)
      })
      .addCase(localLogin.rejected, (state, action) => {
        state.status = requestStatus.Rejected
        state.error = action.payload
      })
  },
})

export const getToken = (state: RootState): string => state.auth.token
export const getIsLoggedIn = (state: RootState): boolean =>
  state.auth.isLoggedIn
export const getUrlInfo = (state: RootState) =>
  pick(state.auth, ['client_id', 'proxy_url', 'redirect_uri', 'error'])
export const getCurrentUser = (state: RootState): User => state.auth.user

const { login, logout } = authSlice.actions

export { login, logout }

export default authSlice.reducer
