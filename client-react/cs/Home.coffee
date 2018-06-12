`
import React from 'react'
import { Link } from 'react-router-dom'

import { Alert, InputGroup, Container, Row, Col,
  InputGroupAddon,
  InputGroupButtonDropdown,
  InputGroupDropdown,
  Input,
  Button,
  Dropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem } from 'reactstrap';
import AddDB from './modals/addDb'
import {dbs, colls, docs} from './Consumers'
import Collection from './Collection'
`
class Home extends React.Component
  constructor: (props) ->
    super props
    @newDbInput = ''
    @handleDbClick = @handleDbClick.bind this
    @handleCollectionClick = @handleCollectionClick.bind this
    @handleAddDbClick = @handleAddDbClick.bind this
    @state =
      socket: props.socket
      actualdb: ''
      actualcol: ''
      adddbmodal: false

  handleDbClick: (evt) ->
    evt.preventDefault()
    console.log this, evt.target
    @setState ((prevState) =>
      actualdb: evt.target.innerHTML), () =>
        @state.socket.emit "listCol", name: @state.actualdb
        undefined

  handleCollectionClick: (evt) ->
    evt.preventDefault()
    @setState ((prevState) =>
      actualcol: evt.target.innerHTML), () =>
        @state.socket.emit 'listDoc', 
          name: @state.actualdb 
          col: @state.actualcol

  handleAddDbClick: ->
    console.log @state.adddbmodal
    @setState (prevState) ->
      adddbmodal: !prevState.adddbmodal
    undefined

  handleAddDbSubmitClick: ->
    @state.socket.emit 'addDb', name: ref.value

  render: ->
    if @state.actualcol == '' 
      <React.Fragment>
        <AddDB socket={@state.socket} modal={@state.adddbmodal} handleSubmitClick={@handleAddDbSubmitClick} inputRef={el => @newDbInput = el}/>
        <Row>
          <Col sm={12} md={4}>
            <Button color="success" className="w-100" onClick={@handleAddDbClick}>Utwórz bazę danych</Button>
          </Col>
          <Col sm={12} md={4}>
            <Button color="danger" className="w-100">Usuń bazę</Button>
          </Col>
          <Col sm={12} md={4}>
            <Button color="success" className="w-100">Dodaj collection</Button>
          </Col>
        </Row>
        <Row>
          <dbs.Consumer>
            {(dbs) =>
              <Col sm={12} md={6} className="d-flex flex-column">
                {(for db, i in dbs
                  <div className="w-100 p-2 border-dark" onClick={@handleDbClick} key={i}> {db.name} </div>
                )}
              </Col>
            }
          </dbs.Consumer>
          <colls.Consumer>
            {(colls) =>
              <Col sm={12} md={6}>
                {(for col in colls 
                  <div className="w-100 p-2 border-dark" onClick={@handleCollectionClick}> {col.name} </div>
                )}
              </Col>
            }
          </colls.Consumer>
        </Row>
      </React.Fragment>
    else
      <Collection db={@state.actualdb} col={@state.actualcol}/>

export default Home