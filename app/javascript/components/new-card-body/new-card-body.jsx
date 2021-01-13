import {nanoid} from 'nanoid';
import React, {useState, useContext, useEffect, useRef} from 'react';
import {useMutation} from '@apollo/react-hooks';
// ! import Textarea from 'react-textarea-autosize';
import {addCardMutation} from './operations.gql';
import BoardSlugContext from '../../utils/board-slug-context';
import UserContext from '../../utils/user-context';
import './style.less';

const NewCardBody = ({kind, smile, onCardAdded, onGetNewCardID}) => {
  const textInput = useRef();
  const [isEdit, setIsEdit] = useState(false);
  const [newCard, setNewCard] = useState('');
  const [addCard] = useMutation(addCardMutation);

  const boardSlug = useContext(BoardSlugContext);
  const currentUser = useContext(UserContext);

  const toggleOpen = () => setIsEdit(!isEdit);

  useEffect(() => {
    if (isEdit) {
      textInput.current.focus();
    }
  }, [isEdit]);

  const cancelHandler = (evt) => {
    evt.preventDefault();
    setIsEdit(!isEdit);
    setNewCard('');
  };

  const buildNewCard = () => ({
    likes: 0,
    comments: [],
    kind,
    author: currentUser,
    body: newCard,
    id: `tmp-${nanoid()}`
  });

  const submitHandler = async (evt) => {
    const card = buildNewCard();
    evt.preventDefault();

    onCardAdded(card);

    const {data} = await addCard({
      variables: {
        boardSlug,
        kind,
        body: newCard
      }
    });
    if (data.addCard.card) {
      onGetNewCardID(card.id, data.addCard.card.id);
      setNewCard('');
    } else {
      console.log(data.addCard.errors.fullMessages.join(' '));
    }
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        submitHandler(evt);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
      submitHandler(evt);
    }

    if (evt.key === 'Escape') {
      cancelHandler(evt);
      setIsEdit(!isEdit);
      setNewCard('');
    }
  };

  return (
    <div className="column-header">
      <div className="column-header__smile">{smile}</div>
      <div className="column-header__wrapper">
        {isEdit ? (
          <form onSubmit={submitHandler}>
            <textarea
              ref={textInput}
              className="column-header__input"
              autoComplete="off"
              id={`card_${kind}_body`}
              value={newCard}
              placeholder="Express yourself"
              // ! maxRows={2}
              onChange={(evt) => setNewCard(evt.target.value)}
              onKeyDown={handleKeyPress}
            />
            <div className="column-header__buttons">
              <button
                className="column-header__buttons__item"
                type="submit"
                onSubmit={submitHandler}
              >
                Add
              </button>
              <button
                className="column-header__buttons__item"
                type="reset"
                onClick={cancelHandler}
              >
                Cancel
              </button>
            </div>
          </form>
        ) : (
          <h2 className="column-header__title">{kind}</h2>
        )}
      </div>
      <div className="column-header__button" onClick={toggleOpen}>
        +
      </div>
    </div>
  );
};

export default NewCardBody;
