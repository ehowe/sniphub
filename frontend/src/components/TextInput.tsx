import React from 'react'

import Form from 'react-bootstrap/Form'

interface PropsI {
  errorMessage?: string
  onBlur?: (...args: any) => void
  label: string
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void
  value?: string
  valid?: boolean
  type?: 'text' | 'password'
}

const TextInput = (props: PropsI) => {
  const {
    errorMessage,
    onBlur,
    onChange,
    value,
    valid = true,
    label,
    type = 'text',
  } = props

  return (
    <Form.Group>
      <Form.Label>{label}</Form.Label>
      <Form.Control
        onBlur={onBlur}
        onChange={onChange}
        value={value}
        isInvalid={!valid}
        type={type}
      />
      {!valid && errorMessage && (
        <Form.Control.Feedback type="invalid">
          {errorMessage}
        </Form.Control.Feedback>
      )}
    </Form.Group>
  )
}

export default TextInput
