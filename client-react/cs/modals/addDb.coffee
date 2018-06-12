`
import React, {Component, Fragment} from 'react';
import { InputGroup, InputGroupAddon,
  InputGroupButtonDropdown,
  InputGroupDropdown,
  Input,
  Button,Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
`

class AddDB extends Component 
    constructor: (props) ->
        super props
        @toggle = @toggle.bind this
        @handleInput = @handleInput.bind this
        @state =
            socket: props.socket
            modal: props.modal
            dbname: ''
    
    toggle: ->
        @setState (pS) ->
          modal: !pS.modal

    handleInput: (evt) ->
      evt.preventDefault()
      @setState dbname: evt.target.value

    getDerivedStateFromProps: (props, state) ->
        if props.modal isnt state.modal
            modal: props.modal
    
    render: ->
        <Modal isOpen={@state.modal} toggle={@toggle} className={@props.className}>
          <ModalHeader toggle={@toggle}>{@props.title}</ModalHeader>
          <ModalBody>
            <InputGroup>
              <Input placeholder={@props.placeholder} ref={@props.inputRef} value={@state.dbname} onInput={@handleInput}/>
              <InputGroupAddon addonType="append">
                <Button color="secondary" onClick={@props.handleSubmitClick}>Dodaj</Button>
                </InputGroupAddon>
            </InputGroup>
          </ModalBody>
          <ModalFooter>
            <Button color="secondary" onClick={@toggle}>Cancel</Button>
          </ModalFooter>
        </Modal>

export default AddDB