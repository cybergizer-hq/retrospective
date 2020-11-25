import React, {useState, useEffect} from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import Picker from 'emoji-picker-react';
import CommentLikes from './CommentLikes';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {faSmile} from '@fortawesome/free-regular-svg-icons';
import {useMutation} from '@apollo/react-hooks';
import {destroyCommentMutation, updateCommentMutation} from './operations.gql';

const Comment = props => {
  const {comment, deletable, editable, id} = props;
  const [editMode, setEditMode] = useState(false);
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [isDropdownShown, setIsDropdownShown] = useState(false);
  const [inputValue, setInputValue] = useState(comment.content);
  const [destroyComment] = useMutation(destroyCommentMutation);
  const [updateComment] = useMutation(updateCommentMutation);

  useEffect(() => {
    if (inputValue !== comment.content) {
      setInputValue(comment.content);
    }
  }, [props.comment.content]);

  const editModeToggle = () => {
    setEditMode(prevMode => !prevMode);
  };

  const handleChange = e => {
    setInputValue(e.target.value);
  };

  const handleEditClick = () => {
    editModeToggle();
    setIsDropdownShown(false);
  };

  const handleSmileClick = () => {
    setShowEmojiPicker(isShown => !isShown);
  };

  const handleEmojiPickerClick = (_, emoji) => {
    setInputValue(comment => `${comment}${emoji.emoji}`);
  };

  const handleKeyPress = e => {
    if (e.key === 'Enter' && !e.shiftKey) {
      editModeToggle();
      updateComment({
        variables: {
          id,
          content: e.target.value
        }
      }).then(({data}) => {
        if (!data.updateComment.comment) {
          setInputValue(comment.content);
          console.log(data.updateComment.errors.fullMessages.join(' '));
        }
      });
      setShowEmojiPicker(false);
    }
  };

  const removeComment = () => {
    destroyComment({
      variables: {
        id
      }
    }).then(({data}) => {
      if (!data.destroyComment.id) {
        console.log(data.destroyComment.errors.fullMessages.join(' '));
      }
    });
  };

  return (
    <>
      <div key={id} className="dropdown-item">
        {editable && deletable && (
          <div className="dropdown">
            <div
              className="dropdown-btn"
              tabIndex="1"
              onClick={() => setIsDropdownShown(!isDropdownShown)}
              onBlur={() => setIsDropdownShown(false)}
            >
              …
            </div>
            <div hidden={!isDropdownShown} className="dropdown-content">
              {!editMode && (
                <div>
                  <a
                    onClick={() => handleEditClick()}
                    onMouseDown={event => {
                      event.preventDefault();
                    }}
                  >
                    Edit
                  </a>
                  <hr style={{margin: '5px 0'}} />
                </div>
              )}
              <a
                onClick={removeComment}
                onMouseDown={event => {
                  event.preventDefault();
                }}
              >
                Delete
              </a>
            </div>
          </div>
        )}
        {!editMode && (
          <>
            <div
              className="columns"
              onDoubleClick={editable ? editModeToggle : undefined}
            >
              <div
                className="column"
                style={{wordBreak: 'break-all', whiteSpace: 'pre-line'}}
              >
                {comment.content}
              </div>
            </div>
            <div className="columns">
              <div className="column is-one-fifth">
                <CommentLikes id={comment.id} likes={comment.likes} />
              </div>
              <div className="column is-offset-two-fifths is-two-fifths bottom-content">
                <img src={comment.author.avatar.thumb.url} className="avatar" />
                <span> by {comment.author.email.split('@')[0]}</span>
              </div>
            </div>
          </>
        )}
        {editMode && (
          <>
            <TextareaAutosize
              value={inputValue}
              hidden={!editMode}
              onChange={handleChange}
              onKeyPress={handleKeyPress}
            />
            <a className="has-text-info" onClick={handleSmileClick}>
              <FontAwesomeIcon icon={faSmile} />
            </a>
          </>
        )}
      </div>
      {showEmojiPicker && (
        <Picker style={{width: 'auto'}} onEmojiClick={handleEmojiPickerClick} />
      )}
    </>
  );
};

export default Comment;
