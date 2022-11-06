import axios from 'axios'
import Cookies from 'js-cookie'

export const API_URL = process.env.REACT_APP_API_URL
export const API_PORT = process.env.REACT_APP_API_PORT

export interface RequestT {
  config?: any
  data?: any
  headers?: any
  method?: 'get' | 'post' | 'put' | 'patch' | 'delete'
  params?: any
  path: string
}

export interface GenericSuccessResponse {
  success: boolean
}

export type ResponseWithStatus<T> = T & {
  status: number
  statusText: string
}

export type ResponseWithStatusPromise<T> = Promise<ResponseWithStatus<T>>

async function request<T = any>(props: RequestT): ResponseWithStatusPromise<T> {
  const {
    config: configProp = {},
    data = {},
    method = 'get',
    params = {},
    path,
  } = props

  const headers = {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    ...props.headers,
  }

  const args: [any, any?, any?] = [path]

  const token = Cookies.get('jwt_token')

  if (token) {
    headers.Authorization = `Bearer ${token}`
  }

  const config = {
    headers,
    ...configProp,
  }

  if (['put', 'post', 'patch'].includes(method)) {
    args.push(data)
    args.push(config)
  } else if (['get', 'delete'].includes(method)) {
    args.push({ params, ...config })
  }

  const response = await axios[method]<T>(path, args[1], args[2])

  return {
    ...response.data,
    status: response.status,
    statusText: response.statusText,
    headers: response.headers,
  }
}

const destroy = async <T = any>(
  props: RequestT
): ResponseWithStatusPromise<T> => request({ ...props, method: 'delete' })
const put = async <T = any>(props: RequestT): ResponseWithStatusPromise<T> =>
  request({ ...props, method: 'put' })
const post = async <T = any>(props: RequestT): ResponseWithStatusPromise<T> =>
  request({ ...props, method: 'post' })
const patch = async <T = any>(props: RequestT): ResponseWithStatusPromise<T> =>
  request({ ...props, method: 'patch' })
const get = async <T = any>(props: RequestT): ResponseWithStatusPromise<T> =>
  request({ ...props, method: 'get' })

const obj = {
  destroy,
  get,
  patch,
  post,
  put,
  request,
}

export default obj
