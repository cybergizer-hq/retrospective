import React from 'react';
import ReactDOM from 'react-dom';
import {ReadyButton} from '../components/ready-button';
import {Provider} from '../components/provider';
import BoardSlugContext from '../utils/board-slug-context';

const element = (
  <Provider>
    <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
      <ReadyButton />
    </BoardSlugContext.Provider>
  </Provider>
);
document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(element, document.querySelector('#ready-button'));
});
