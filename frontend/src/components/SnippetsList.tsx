import React from 'react'
import { Link } from 'react-router-dom'

import Button from 'react-bootstrap/Button'
import Spinner from 'react-bootstrap/Spinner'
import Table from 'react-bootstrap/Table'

import { useAppDispatch, useAppSelector } from '../app/hooks'
import {
  createSnippet,
  getSnippets,
  snippetsLoading,
} from '../app/reducers/snippets'

import './SnippetsList.scss'

const SnippetsList = () => {
  const dispatch = useAppDispatch()
  const snippets = useAppSelector(getSnippets)
  const snippetsAreLoading = useAppSelector(snippetsLoading)

  if (snippetsAreLoading) {
    return (
      <Spinner animation="border" role="status">
        <span className="visually-hidden">Loading...</span>
      </Spinner>
    )
  }

  const onCreateSnippet = () => {
    dispatch(createSnippet())
  }

  return (
    <div className="snippets-list">
      <Table striped bordered hover>
        <thead>
          <tr>
            <td>ID</td>
            <td>Name</td>
            <td>Language</td>
            <td>Public</td>
            <td>Last updated</td>
          </tr>
        </thead>
        <tbody>
          {snippets.map((snippet) => (
            <tr key={snippet.id}>
              <td>
                <Link to={`/snippets/${snippet.id}`}>{snippet.id}</Link>
              </td>
              <td>{snippet.name}</td>
              <td>{snippet.language}</td>
              <td>{snippet.public.toString()}</td>
              <td>{snippet.updated_at}</td>
            </tr>
          ))}
        </tbody>
      </Table>
      <Button className="create-button" onClick={onCreateSnippet}>
        Create
      </Button>
    </div>
  )
}

export default SnippetsList
