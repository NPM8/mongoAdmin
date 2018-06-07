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

import Home from './Home'
import About from './About'
`
dbs = React.createContext []
colls = React.createContext []

class App extends Component
  constructor: (props) ->
    super props

    @handleUserURLInput = @handleUserURLInput.bind this
    @handleConnect = @handleConnect.bind this
    @state = 
      socket: io()
      dbs: []
      colls: []
      userVUrl: ''
      userUrl: ''
      err: ''
    @state.socket.on 'dbs', (data) =>
      @setState dbs: data.array
    @state.socket.on 'collections', (data) =>
      @setState colls: data.data

  handleUserURLInput: (evt) ->
    @setState userVUrl: evt.target.value
    
  handleConnect: (evt) ->
    @setState (prevState) ->
      console.log prevState
      userUrl: prevState.userVUrl
    @state.socket.emit 'connect', url: @state.userVUrl
   
  
  render: ->
    <dbs.Provider value={@state.dbs}>
    <colls.Provider value={@state.colls}>
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
          <Switch>
            <Container>
              <Route exact path="/" render={ Home } socket={@state.socket}/>
              <Route path="/col/:db/:col" render={ About } />
            </Container>
          </Switch>
        else
          <div className="w-100 max-height d-flex flex-column justify-content-center ">
            <div className="w-100 d-md-flex justify-content-center">
              <InputGroup className="w-25">
                <Input placeholder="username" value={@state.userVUrl} onInput={@handleUserURLInput}/>
                <InputGroupAddon addonType="append">
                  <Button color="secondary" onClick={@handleConnect}>
                    I'm a button
                  </Button>
                </InputGroupAddon>
              </InputGroup>
            </div>
          </div>
        }
        
      </div>
    </Router>
    </colls.Provider>
    </dbs.Provider>

export default App
