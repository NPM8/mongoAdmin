`
import React, { Component } from 'react'

import {
  BrowserRouter as Router,
  Route,
  Switch
} from 'react-router-dom'

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

import io from 'socket.io-client'

import logo from './logo.svg'
import './App.css'
import {dbs, colls, docs} from './Consumers'
import Home from './Home'
import About from './About'
import Collection from './Collection'
`

class App extends Component
  constructor: (props) ->
    super props
    @socket = io()
    @handleUserURLInput = @handleUserURLInput.bind this
    @handleConnect = @handleConnect.bind this
    @state =
      socket: io()
      dbs: [
        name: 'ala ma kota'
      ]
      colls: []
      userVUrl: ''
      userUrl: ''
      err: ''
      docs: ''
    @state.socket.on 'dbs', (data) =>
      @setState dbs: data.array.databases
      # console.log data
    @state.socket.on 'collections', (data) =>
      @setState colls: data.data
    @state.socket.on 'docs', (data) =>
      @setState docs: data.data

  handleUserURLInput: (evt) ->
    @setState userVUrl: evt.target.value

  handleConnect: (evt) ->
    @setState ((prevState) ->
      console.log prevState
      userUrl: prevState.userVUrl), ->
        @state.socket.emit 'connectTo', url: @state.userVUrl
    undefined


  render: ->
    <dbs.Provider value={@state.dbs}>
    <colls.Provider value={@state.colls}>
    <docs.Provider value={@state.docs}>
    <Router>
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React (CS)</h1>
        </header>
        <p className="App-intro">
          Mongo My Admin test enviroment
        </p>
        {if (@state.err)? and (@state.err) != ''
          <Alert color="danger"> Something wthent wrong: {@state.err}</Alert>}
        {if (@state.userUrl)? and (@state.userUrl) != ''
            <Container>
              <Home socket={@state.socket} />
            </Container>
        else
          <div className="w-100 max-height d-flex flex-column justify-content-center ">
            <div className="w-100 d-md-flex justify-content-center">
              <InputGroup className="w-25">
                <Input placeholder="username" value={@state.userVUrl} onInput={@handleUserURLInput}/>
                <InputGroupAddon addonType="append">
                  <Button color="secondary" onClick={@handleConnect}>
                    Connect
                  </Button>
                </InputGroupAddon>
              </InputGroup>
            </div>
          </div>
        }

      </div>
    </Router>
    </docs.Provider>
    </colls.Provider>
    </dbs.Provider>

export default App
