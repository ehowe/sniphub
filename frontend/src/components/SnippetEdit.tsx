import React from 'react'
import { useParams } from 'react-router-dom'

import { useAppSelector, useAppDispatch } from '../app/hooks'
import { getSnippet, updateSnippet } from '../app/reducers/snippets'
import languages from '../app/languages'

import Column from 'react-bootstrap/Col'
import Form from 'react-bootstrap/Form'
import AceEditor from 'react-ace-builds'
import 'react-ace-builds/webpack-resolver-min'

import type { Snippet } from '../app/types'

import './SnippetEdit.scss'

const SnippetEdit = () => {
  const { id } = useParams()
  const dispatch = useAppDispatch()

  const snippet = useAppSelector((state) => getSnippet(state, id))
  const [name, setName] = React.useState(snippet.name || '')
  const [content, setContent] = React.useState(snippet.content)

  const [language, setLanguage] = React.useState(
    snippet.language?.toLowerCase() || ''
  )

  const updateApiSnippet = (params: Snippet) => {
    dispatch(updateSnippet(params))
  }

  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setName(e.target.value)

    updateApiSnippet({ ...snippet, name: e.target.value })
  }

  const handleLanguageChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setLanguage(e.target.value)

    updateApiSnippet({ ...snippet, language: e.target.value })
  }

  const handleContentChange = (content: string) => {
    setContent(content)

    updateApiSnippet({ ...snippet, content })
  }

  React.useEffect(() => {
    setLanguage(snippet.language?.toLowerCase())
  }, [snippet.language])

  return (
    <Column className="snippets-edit">
      <Form>
        <Form.Group>
          <Form.Label>Name</Form.Label>
          <Form.Control
            onChange={handleNameChange}
            placeholder="Enter a name"
            type="text"
            value={name}
          />
        </Form.Group>
        <Form.Group>
          <Form.Label>Language</Form.Label>
          <Form.Select value={language} onChange={handleLanguageChange}>
            <option>Select a language</option>
            {languages.map((language) => (
              <option key={language} value={language.toLowerCase()}>
                {language}
              </option>
            ))}
          </Form.Select>
        </Form.Group>
        <Form.Group>
          <Form.Label>Content</Form.Label>
          <AceEditor
            className="snippet-code-editor"
            mode={language}
            onChange={handleContentChange}
            showGutter
            setOptions={{ showLineNumbers: true }}
            showPrintMargin
            theme="monokai"
            value={content}
            width="100%"
          />
        </Form.Group>
      </Form>
      {id}
    </Column>
  )
}

export default SnippetEdit
