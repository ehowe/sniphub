import React from 'react'

import { useParams, useSearchParams } from 'react-router-dom'
// import { confirmRegistration } from '../app/reducers/users'

const Profile = () => {
  const { id } = useParams()
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token')

  React.useEffect(() => {}, [token])

  console.log({ id })

  return <div>Profile</div>
}

export default Profile
