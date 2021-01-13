import React, {useRef, useState, useContext, useEffect} from 'react';
import Picker from 'emoji-picker-react';
import Textarea from 'react-textarea-autosize';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {faSmile} from '@fortawesome/free-regular-svg-icons';
import UserContext from '../../utils/user-context';
import {Comment} from '../comment';
import {useMutation} from '@apollo/react-hooks';
import {addCommentMutation} from './operations.gql';
import './style.less';

const CommentsDropdown = ({id, comments, onClickClosed}) => {
  const controlElement = useRef(null);
  const textInput = useRef();
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [isError, setIsError] = useState(false);
  const user = useContext(UserContext);
  const [newComment, setNewComment] = useState('');
  const [addComment] = useMutation(addCommentMutation);

  useEffect(() => {
    textInput.current.focus();
  }, []);

  const handleErrorSubmit = () => {
    setNewComment('');
    setIsError(true);
  };

  const handleSuccessSubmit = () => {
    setNewComment('');
    setIsError(false);
  };

  const handleSubmit = () => {
    controlElement.current.disabled = true;
    addComment({
      variables: {
        cardId: id,
        content: newComment
      }
    }).then(({data}) => {
      if (data.addComment.comment) {
        handleSuccessSubmit();
      } else {
        console.log(data.addComment.errors.fullMessages.join(' '));
        handleErrorSubmit();
      }
    });
    controlElement.current.disabled = false;
    setShowEmojiPicker(false);
  };

  const handleSmileClick = () => {
    setShowEmojiPicker((isShown) => !isShown);
  };

  const handleEmojiPickerClick = (_, emoji) => {
    setNewComment((comment) => `${comment}${emoji.emoji}`);
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        handleSubmit(evt);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
      handleSubmit(evt);
    }

    if (evt.key === 'Escape') {
      onClickClosed();
    }
  };

  return (
    <div className="comments">
      <div className="comments__wrapper">
        {comments.map((item) => (
          <Comment
            key={item.id}
            id={item.id}
            comment={item}
            deletable={user === item.author.email}
            editable={user === item.author.email}
          />
        ))}
      </div>
      <div className="new-comment">
        <Textarea
          ref={textInput}
          className="new-comment__textarea"
          value={newComment}
          style={isError ? {outline: 'solid 1px red'} : {}}
          onChange={(evt) => setNewComment(evt.target.value)}
          onKeyDown={handleKeyPress}
        />
        <a className="new-comment__smile" onClick={handleSmileClick}>
          <FontAwesomeIcon icon={faSmile} />
        </a>
      </div>
      <div className="new-comment__buttons">
        <button
          type="button"
          className="new-comment__buttons__item new-comment__buttons__item--hide"
          onClick={() => onClickClosed()}
        >
          hide discussion
        </button>
        <button
          ref={controlElement}
          className="new-comment__buttons__item new-comment__buttons__item--add"
          type="button"
          onClick={() => handleSubmit(newComment)}
        >
          post
        </button>
      </div>
      {showEmojiPicker && (
        <Picker style={{width: 'auto'}} onEmojiClick={handleEmojiPickerClick} />
      )}
    </div>
  );
};

export default CommentsDropdown;
