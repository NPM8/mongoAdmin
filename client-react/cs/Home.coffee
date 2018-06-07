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

`
class Home extends React.Component
  constructor: (props) ->
    super props

    @state =
      socket: props.socket
      actualdb: ''
    

  render: ->
    <React.Fragment>
      <Row>
        <Col sm={12} md={4}>
          <Button color="success" className="w-100">Utwórz bazę danych</Button>
        </Col>
        <Col sm={12} md={4}>
          <Button color="success" className="w-100">Usuń bazę</Button>
        </Col>
        <Col sm={12} md={4}>
          <Button color="success" className="w-100">Dodaj collection</Button>
        </Col>
      </Row>
      <Row>
        <dbs.Consumer>
          {(dbs) =>
            <Col sm={12} md={6}>
              {(for db in dbs
                db
              ).bind this}
            </Col>
          }
        </dbs.Consumer>
        <colls.Consumer>
          {(colls) =>
            <Col sm={12} md={6}>
              {(for col in colls 
                col
              ).bind this}
            </Col>
          }
        </colls.Consumer>
      </Row>
    </React.Fragment>

export default Home
