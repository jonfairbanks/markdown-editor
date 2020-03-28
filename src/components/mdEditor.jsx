import React, { Component } from 'react';
import Editor from 'react-editor-md';

import config from '../config/config.json'

export class mdEditor extends Component {
  render() {
    return (
      <Editor config={
        {
          markdown: config.markdown,
          theme: config.toolbarTheme,
          editorTheme: config.editorTheme,
          previewTheme: config.previewTheme,
          imageUpload: false,
          width: config.width,
          height: config.height,
          lang: 'en',
          onload: (editor, func) => {
            /*eslint-disable */
            let md = editor.getMarkdown();
            let html = editor.getHTML();
            /*eslint-enable */
          }
        }
      }/>
    );
  }
}

export default mdEditor;