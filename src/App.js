import React from 'react'
import './App.css'
import Editor from './components/mdEditor'

import config from './config/config'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <a
          className="App-link"
          href={config.headerLink}
          target="_blank"
          rel="noopener noreferrer"
        >
          Markdown Editor
        </a>
      </header>
      <Editor />
    </div>
  )
}

export default App
