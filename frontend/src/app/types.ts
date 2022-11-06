export enum requestStatus {
  Idle = 'idle',
  Loading = 'loading',
  Success = 'success',
  Rejected = 'rejected',
}

export interface Snippet {
  content: string
  created_at: string
  id: string
  language: string
  name: string
  public: boolean
  updated_at: string
}

export interface User {
  external_provider?: string
  id: string
  first_name: string
  last_name: string
  username: string
}
