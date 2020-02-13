import React from 'react';
import ReactDOM from 'react-dom';

const Board = () => <h1>Board</h1>;

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<ReadyButton />, document.querySelector('#board'));
});
