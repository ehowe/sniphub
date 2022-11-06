import React from 'react'
import { useAppDispatch } from 'app/hooks'
import { logout } from 'app/reducers/auth'

const Logout = () => {
  const dispatch = useAppDispatch()

  React.useEffect(() => {
    dispatch(logout())
  }, [])

  return <></>
}

export default Logout
