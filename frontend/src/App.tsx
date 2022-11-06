import React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Routes,
  Navigate,
} from 'react-router-dom'

import Column from 'react-bootstrap/Col'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'

import './App.scss'
import 'bootstrap/dist/css/bootstrap.min.css'

import Login from 'components/Login'
import Logout from 'components/Logout'
import Profile from 'components/Profile'
import Sidebar from 'components/Sidebar'
import SnippetEdit from 'components/SnippetEdit'
import SnippetsList from 'components/SnippetsList'

import { useAppDispatch, useAppSelector } from 'app/hooks'
import { getToken } from 'app/reducers/auth'
import { fetchSnippets } from 'app/reducers/snippets'

function App() {
  const dispatch = useAppDispatch()
  const token = useAppSelector(getToken)

  React.useEffect(() => {
    dispatch(fetchSnippets())
  }, [token])

  return (
    <div className="Sniphub">
      <Router>
        <Container fluid>
          <Row>
            <Column xs={2}>
              <Sidebar />
            </Column>
            <Column>
              <Routes>
                <Route path="/login" element={<Login />} />
                <Route path="/users/*">
                  <Route path="me" element={<Profile />} />
                  <Route path="logout" element={<Logout />} />
                  <Route path=":id">
                    <Route path="confirm" element={<Profile />} />
                  </Route>
                </Route>
                <Route path="snippets/*">
                  <Route path=":id" element={<SnippetEdit />} />
                  <Route index element={<SnippetsList />} />
                </Route>
                <Route path="*" element={<Navigate to="/snippets" />} />
              </Routes>
            </Column>
          </Row>
        </Container>
      </Router>
    </div>
  )
}

export default App
