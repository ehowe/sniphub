import React from 'react'

import RBModal from 'react-bootstrap/Modal'

export interface PropsI {
  heading: string
  visible: boolean
  onHide: () => void
  children: React.ReactNode | React.ReactNode[]
  size?: 'sm' | 'lg' | 'xl'
}

const Modal = (props: PropsI) => (
  <RBModal show={props.visible} onHide={props.onHide} size={props.size || 'lg'}>
    <RBModal.Header closeButton>{props.heading}</RBModal.Header>
    <RBModal.Body>{props.children}</RBModal.Body>
  </RBModal>
)

export default Modal
