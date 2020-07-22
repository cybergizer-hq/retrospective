import React, {useState, useContext, useEffect} from 'react';
import {useMutation, useSubscription} from '@apollo/react-hooks';
import Card from './Card';
import {
  cardAddedSubscription,
  cardDestroyedSubscription,
  cardUpdatedSubscription,
  addCardMutation
} from './operations.gql';
import Textarea from 'react-textarea-autosize';
import UserContext from '../../utils/user_context';
import BoardSlugContext from '../../utils/board_slug_context';
import '../table.css';
const CardColumn = props => {
  const user = useContext(UserContext);
  const boardSlug = useContext(BoardSlugContext);
  const {kind, initCards} = props;

  const [cards, setCards] = useState(initCards);
  const [newCard, setNewCard] = useState('');
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  const [addCard] = useMutation(addCardMutation);

  useSubscription(cardAddedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {cardAdded} = data;
      if (cardAdded) {
        if (
          cardAdded.kind === kind &&
          cards.findIndex(element => element.id === cardAdded.id) === -1
        ) {
          setCards(oldCards => [...oldCards, cardAdded]);
        }
      }
    },
    variables: {boardSlug}
  });

  useSubscription(cardDestroyedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {cardDestroyed} = data;
      if (cardDestroyed && cardDestroyed.kind === kind) {
        setCards(oldCards => oldCards.filter(el => el.id !== cardDestroyed.id));
      }
    },
    variables: {boardSlug}
  });

  useSubscription(cardUpdatedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {cardUpdated} = data;
      if (cardUpdated && cardUpdated.kind === kind) {
        setCards(oldCards => {
          const cardIdIndex = oldCards.findIndex(
            element => element.id === cardUpdated.id
          );
          if (cardIdIndex >= 0) {
            return [
              ...oldCards.slice(0, cardIdIndex),
              cardUpdated,
              ...oldCards.slice(cardIdIndex + 1)
            ];
          }

          return oldCards;
        });
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkip(false);
  }, []);

  const submitHandler = e => {
    e.preventDefault();
    addCard({
      variables: {
        boardSlug,
        kind,
        body: newCard
      }
    }).then(({data}) => {
      if (data.addCard.card) {
        setNewCard('');
      } else {
        console.log(data.addCard.errors.fullMessages.join(' '));
      }
    });
  };

  const handleKeyPress = e => {
    if (e.key === 'Enter' && !e.shiftKey) {
      submitHandler(e);
    }
  };

  return (
    <>
      <div className="box">
        <form onSubmit={submitHandler}>
          <h2> Add new {kind} card</h2>
          <Textarea
            className="input"
            autoComplete="off"
            id={`card_${kind}_body`}
            value={newCard}
            onChange={e => setNewCard(e.target.value)}
            onKeyPress={handleKeyPress}
          />
          <div className="btn-save">
            <button
              className="tag is-info button"
              type="submit"
              onSubmit={submitHandler}
            >
              Add
            </button>
          </div>
        </form>
      </div>

      {cards.map(card => {
        return (
          <Card
            key={card.id}
            id={card.id}
            author={card.author.email.split('@')[0]}
            avatar={card.author.avatar.thumb.url}
            body={card.body}
            comments={card.comments}
            likes={card.likes}
            type={kind}
            editable={user === card.author.email}
            deletable={user === card.author.email}
          />
        );
      })}
    </>
  );
};

export default CardColumn;
