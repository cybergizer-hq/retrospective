import React, {useState, useContext, useEffect, useCallback} from 'react';
import {useMutation, useSubscription} from '@apollo/react-hooks';
import Card from './Card';
import CardPopup from './Card/card-popup/card-popup.jsx';
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

const CardColumn = ({kind, initCards}) => {
  const user = useContext(UserContext);
  const boardSlug = useContext(BoardSlugContext);

  const [cards, setCards] = useState(initCards);
  const [newCard, setNewCard] = useState('');
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  const [popupShownId, setPopupShownId] = useState(null);

  const [addCard] = useMutation(addCardMutation);

  const handleCommentButtonClick = id => () => setPopupShownId(id);
  const handlePopupClose = () => setPopupShownId(null);

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
          setCards(oldCards => [cardAdded, ...oldCards]);
          setOpened(true);
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

  const cancelHandler = e => {
    e.preventDefault();
    setOpened(opened => !opened);
    setNewCard('');
  };

  const [isOpened, setOpened] = useState(false);
  const handleOpenBox = useCallback(() => {
    setOpened(isOpened => !isOpened);
  }, [setOpened]);

  const handleKeyPress = e => {
    if (navigator.platform.includes('Mac')) {
      if (e.key === 'Enter' && e.metaKey) {
        submitHandler(e);
      }
    } else if (e.key === 'Enter' && e.ctrlKey) {
      submitHandler(e);
    }

    if (e.key === 'Escape') {
      setOpened(opened => !opened);
      setNewCard('');
    }
  };

  const card = cards.find(it => it.id === popupShownId);
  return (
    <>
      <div className="board-column-title">
        <h2 className="float_left">{kind.toUpperCase()}</h2>
        <div className="float_right card-new" onClick={handleOpenBox}>
          +
        </div>
      </div>
      {isOpened && (
        <div>
          <form onSubmit={submitHandler}>
            <Textarea
              autoFocus
              className="input"
              autoComplete="off"
              id={`card_${kind}_body`}
              value={newCard}
              onChange={e => setNewCard(e.target.value)}
              onKeyDown={handleKeyPress}
            />
            <div className="card-buttons">
              <button
                className="tag is-success button card-add"
                type="submit"
                onSubmit={submitHandler}
              >
                Add
              </button>
              <button
                className="tag button card-cancel"
                type="submit"
                onClick={cancelHandler}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {cards.map(card => {
        return (
          <Card
            key={card.id}
            id={card.id}
            nickname={card.author.nickname}
            lastName={card.author.last_name} // TO DO: will be rewritten
            firstName={card.author.first_name} // TO DO: will be rewritten
            avatar={card.author.avatar.thumb.url}
            body={card.body}
            likes={card.likes}
            type={kind}
            commentsNumber={card.comments.length}
            editable={user === card.author.email}
            deletable={user === card.author.email}
            onCommentButtonClick={handleCommentButtonClick(card.id)}
          />
        );
      })}

      {popupShownId && (
        <CardPopup
          id={card.id}
          nickname={card.author.nickname}
          lastName={card.author.last_name} // TO DO: will be rewritten
          firstName={card.author.first_name} // TO DO: will be rewritten
          avatar={card.author.avatar.thumb.url}
          body={card.body}
          likes={card.likes}
          type={kind}
          commentsNumber={card.comments.length}
          editable={user === card.author.email}
          deletable={user === card.author.email}
          comments={card.comments}
          onCommentButtonClick={() => {}}
          onClickClosed={handlePopupClose}
        />
      )}
    </>
  );
};

export default CardColumn;
