import {
  createAsyncThunk,
  createEntityAdapter,
  createSlice,
} from '@reduxjs/toolkit'

import request, { API_URL, API_PORT } from '../request'
import pick from 'lodash/pick'

import type { RootState } from '../store'
import type { Snippet } from '../types'
import { requestStatus } from '../types'

const snippetAdapter = createEntityAdapter<Snippet>()

const initialState = snippetAdapter.getInitialState({
  ids: [],
  entities: {},
  status: requestStatus.Idle,
  error: null,
  type: '',
})

interface SnippetsResponse {
  snippets: Snippet[]
}

interface SnippetResponse {
  snippet: Snippet
}

type UpdateOptions = Pick<
  Snippet,
  'id' | 'name' | 'language' | 'public' | 'content'
>

const SNIPPET_API = `${[API_URL, API_PORT].join(':')}/api/snippets`

export const fetchSnippets = createAsyncThunk('snippets/fetch', async <
  T = SnippetsResponse
>(): Promise<T> => {
  return await request.get<T>({
    path: SNIPPET_API,
  })
})

export const updateSnippet = createAsyncThunk(
  'snippets/update',
  async (options: UpdateOptions): Promise<SnippetResponse> => {
    const path = `${SNIPPET_API}/${options.id}`

    return await request.put<SnippetResponse>({
      path,
      data: pick(options, ['name', 'language', 'public', 'content']),
    })
  }
)

export const createSnippet = createAsyncThunk('snippets/create', async () => {
  return await request.post<SnippetResponse>({
    path: SNIPPET_API,
  })
})

const snippetSlice = createSlice({
  name: 'snippets',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchSnippets.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(fetchSnippets.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        snippetAdapter.setAll(state, action.payload.snippets)
      })
      .addCase(updateSnippet.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(updateSnippet.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        snippetAdapter.upsertOne(state, action.payload.snippet)
      })
      .addCase(createSnippet.pending, (state) => {
        state.status = requestStatus.Loading
      })
      .addCase(createSnippet.fulfilled, (state, action) => {
        state.status = requestStatus.Success
        snippetAdapter.upsertOne(state, action.payload.snippet)
      })
  },
})

const entitySelectors = snippetAdapter.getSelectors()

export const snippetsLoading = (state: RootState): boolean =>
  state.snippets.status === requestStatus.Loading

export const getSnippets = (state: RootState): Snippet[] =>
  entitySelectors.selectAll(state.snippets)

export const getSnippet = (state: RootState, id?: string): Snippet => {
  if (!id) return {} as Snippet

  return entitySelectors.selectById(state.snippets, id) || ({} as Snippet)
}

export const getStatus = (state: RootState) => state.snippets.status

export default snippetSlice.reducer
