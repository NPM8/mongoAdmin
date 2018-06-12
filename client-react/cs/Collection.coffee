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

`

class Collection extends React.Component
    constructor: (props) ->
        super props
        @state =
            socket: props.socket

    
    render: ->
        <React.Fragment>
            <Row>
                <Col>
                    <Link to="/"> Back</Link>
                </Col>
                <Col>
                    <Button color="danger"> Usuń collection</Button>
                </Col>
                <Col>
                    <Button color="success"> Dodaj element </Button>
                </Col>
                <Col>
                    <Button color="danger"> Usuń element</Button>
                </Col>
            </Row>
            <Row>
                <docs.Consumer>
                    {(docs) =>
                        <Col className="d-flex flex-column">
                            {for doc in docs
                                <div className="w-100 m-1 p-2 border-dark">{doc.id}</div>
                            }
                        </Col>
                    }
                </docs.Consumer>
                <Col>
                    <textarea className="w-100"></textarea>
                </Col>
            </Row>
        </React.Fragment>

export default Collection