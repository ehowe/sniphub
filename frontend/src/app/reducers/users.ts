import {
  createAsyncThunk,
  createEntityAdapter,
  createSlice,
} from '@reduxjs/toolkit'

import request from '../request'
import pick from 'lodash/pick'

import type { RootState } from '../store'
import type { User } from '../types'
import { requestStatus } from '../types'

const usersAdapter = createEntityAdapter<User>()

const initialState = usersAdapter.getInitialState({
  ids: [],
  entities: {},
  status: requestStatus.Idle,
  error: null,
  type: '',
})

interface UsersResponse {
  users: User[]
}

interface UserResponse {
  user: User
}

type UpdateOptions = Pick<User, 'id' | 'first_name' | 'last_name' | 'username'>
type RegisterOptions = Pick<User, 'first_name' | 'last_name' | 'username'> & {
  password: string
  password_confirmation: string
}

const USER_API = `${[
  process.env.REACT_APP_API_URL,
  process.env.REACT_APP_API_PORT,
].join(':')}/api/users`

export const fetchUsers = createAsyncThunk('users/fetch', async <
  T = UsersResponse
>(): Promise<T> => {
  return await request.get<T>({
    path: USER_API,
  })
})

export const fetchCurrentUser = createAsyncThunk(
  'users/fetchCurrent',
  async (id: string): Promise<UserResponse> => {
    return await request.get<UserResponse>({
      path: `${USER_API}/current`,
    })
  }
)

export const updateUser = createAsyncThunk(
  'users/update',
  async (options: UpdateOptions): Promise<UserResponse> => {
    const path = `${USER_API}/${options.id}`

    return await request.put<UserResponse>({
      path,
      data: pick(options, ['name', 'language', 'public', 'content']),
    })
  }
)

export const registerUser = createAsyncThunk(
  'users/register',
  async (options: RegisterOptions): Promise<UserResponse> => {
    const path = `${USER_API}/register`

    return await request.post<UserResponse>({
      path,
      data: options,
    })
  }
)

export const confirmRegistration = createAsyncThunk(
  'users/confirm',
  async ({
    id,
    token,
  }: {
    id: string
    token: string
  }): Promise<UserResponse> => {
    const path = `${USER_API}/confirm`

    return await request.get<UserResponse>({
      path,
      params: { id, token },
    })
  }
)

const userSlice = createSlice({
  name: 'users',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        usersAdapter.setAll(state, action.payload.users)
      })
      .addCase(updateUser.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(updateUser.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        usersAdapter.upsertOne(state, action.payload.user)
      })
      .addCase(registerUser.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(registerUser.fulfilled, (state) => {
        state.status = requestStatus.Success
      })
      .addCase(confirmRegistration.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(confirmRegistration.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        usersAdapter.upsertOne(state, action.payload.user)
      })
  },
})

const entitySelectors = usersAdapter.getSelectors()

export const getUsers = (state: RootState): User[] =>
  entitySelectors.selectAll(state.users)

export const getUser = (state: RootState, id?: string): User => {
  if (!id) return {} as User

  return entitySelectors.selectById(state.users, id) || ({} as User)
}

export const getStatus = (state: RootState) => state.users.status

export default userSlice.reducer
