import React from 'react'
import classnames from 'classnames'
import { Nav } from 'react-bootstrap'
import { LinkContainer } from 'react-router-bootstrap'

import { useAppSelector } from 'app/hooks'
import { getCurrentUser } from 'app/reducers/auth'

import './Sidebar.scss'

const Sidebar = () => {
  const user = useAppSelector(getCurrentUser)

  return (
    <>
      <Nav
        className={classnames('flex-column', 'sidebar')}
        activeKey="/snippets"
      >
        <LinkContainer to="/snippets">
          <Nav.Link>Snippets</Nav.Link>
        </LinkContainer>
        <LinkContainer to="/tags">
          <Nav.Link>Tags</Nav.Link>
        </LinkContainer>
        {user && (
          <>
            <LinkContainer to="/users/me">
              <Nav.Link>Account</Nav.Link>
            </LinkContainer>
            <LinkContainer to="/users/logout">
              <Nav.Link>Logout</Nav.Link>
            </LinkContainer>
          </>
        )}
        {!user && (
          <LinkContainer to="/login">
            <Nav.Link>Login</Nav.Link>
          </LinkContainer>
        )}
      </Nav>
    </>
  )
}

export default Sidebar
