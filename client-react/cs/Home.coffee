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

import {dbs, colls, docs} from './Consumers'
import Collection from './Collection'
`
class Home extends React.Component
  constructor: (props) ->
    super props
    @handleDbClick = @handleDbClick.bind this
    @state =
      socket: props.socket
      actualdb: ''
      actualcol: ''

  handleDbClick: (evt) ->
    tmp = evt
    console.log this, evt
    @setState ((prevState) =>
      actualdb: tmp), () =>
        @state.socket.emit "listCol", name: @state.actualdb
        undefined

    

  render: ->
    if @state.actualcol == '' 
      <React.Fragment>
        <Row>
          <Col sm={12} md={4}>
            <Button color="success" className="w-100">Utwórz bazę danych</Button>
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
                {(for db in dbs
                  <div className="w-100" onClick={() => 
                    ala = 
                      test: db.name
                    @handleDbClick(ala)}> {db.name} </div>
                )}
              </Col>
            }
          </dbs.Consumer>
          <colls.Consumer>
            {(colls) =>
              <Col sm={12} md={6}>
                {(for col in colls 
                  <div className="w-100" onClick={() => 
                    ala = 
                      test: col.name
                    @handleDbClick(ala)}> {col.name} </div>
                )}
              </Col>
            }
          </colls.Consumer>
        </Row>
      </React.Fragment>
    else
      <Collection db={@state.actualdb} col={@state.actualcol}/>

export default Home