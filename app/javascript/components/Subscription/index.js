import React, {Component} from 'react';
import gql from 'graphql-tag';
import {Query} from 'react-apollo';

const GET_BOARDS = gql`
  query {
    boards {
      id
      slug
      title
      createdAt
      updatedAt
      cards {
        author {
          id
          avatar
          email
          createdAt
          updatedAt
        }
        id
        authorId
        boardId
        likes
        updatedAt
        createdAt
        kind
      }
    }
  }
`;

const NEW_CARD = gql`
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
`;

export class CardsSubscription extends Component {
  _subscribeToNewCards = subscribeToMore => {
    subscribeToMore({
      document: NEW_CARD,
      updateQuery: (prev, {subscriptionData}) => {
        if (!subscriptionData.data) return prev;

        const newCard = subscriptionData.data.cardAdded;

        return {
          ...prev,
          cards: [newCard, ...prev.boards],
          __typename: prev.boards.__typename
        };
      }
    });
  };

  render() {
    return (
      <Query query={GET_BOARDS}>
        {({loading, error, data, subscribeToMore}) => {
          if (loading) return <div>Fetching</div>;
          if (error) return <div>Error</div>;

          this._subscribeToNewCards(subscribeToMore);

          const cardsToRender = data.boards;
          console.log(cardsToRender);
          return <div>{/* TODO */}</div>;
        }}
      </Query>
    );
  }
}
