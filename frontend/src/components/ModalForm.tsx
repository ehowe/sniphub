import React from 'react'

import Button from 'react-bootstrap/Button'
import Form from 'react-bootstrap/Form'
import Modal from './Modal'

import type { PropsI } from './Modal'

interface ModalFormPropsI extends PropsI {
  onSubmit: () => void
  submitText?: string
}

const ModalForm = (props: ModalFormPropsI) => (
  <Modal
    visible={props.visible}
    onHide={props.onHide}
    size={props.size || 'lg'}
    heading={props.heading}
  >
    <Form>{props.children}</Form>
    <div style={{ paddingTop: '1em', display: 'flex' }}>
      <Button style={{ marginRight: '1em' }} onClick={props.onSubmit}>
        {props.submitText || 'Submit'}
      </Button>
      <Button onClick={props.onHide}>Cancel</Button>
    </div>
  </Modal>
)

export default ModalForm
