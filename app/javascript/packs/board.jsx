import React from 'react';
import ReactDOM from 'react-dom';
import gql from 'graphql-tag';

const Board = () => <h1>Board</h1>;

const SUBSCRIPTION_CARD_ADDED = gql`
  subscription {
    cardAdded {
      author {
        id
        email
        avatar
        updatedAt
        createdAt
      }
      id
      authorId
      boardId
      body
      likes
      updatedAt
      createdAt
      kind
    }
  }
`

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Board />, document.querySelector('#board'));
});
