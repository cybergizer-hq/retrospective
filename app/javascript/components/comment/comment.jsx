import React, {useState, useEffect} from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import Picker from 'emoji-picker-react';
//
//  import {CommentLikes} from '../comment-likes';
import {CardUser} from '../card-user';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {faSmile} from '@fortawesome/free-regular-svg-icons';
//
// import {useMutation} from '@apollo/react-hooks';
//
// import {destroyCommentMutation, updateCommentMutation} from './operations.gql';
import {Linkify, linkifyOptions} from '../../utils/linkify';
import './style.less';

const Comment = ({comment, editable}) => {
  //
  // id, deletable
  const [editMode, setEditMode] = useState(false);
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  //
  // const [isDropdownShown, setIsDropdownShown] = useState(false);
  const [inputValue, setInputValue] = useState(comment.content);
  //
  // const [destroyComment] = useMutation(destroyCommentMutation);
  // const [updateComment] = useMutation(updateCommentMutation);

  useEffect(() => {
    if (inputValue !== comment.content) {
      setInputValue(comment.content);
    }
  }, [comment.content]);

  const editModeToggle = () => {
    setEditMode(!editMode);
  };

  const handleChange = (evt) => {
    setInputValue(evt.target.value);
  };

  //
  // const handleEditClick = () => {
  //   editModeToggle();
  //   setIsDropdownShown(false);
  // };

  const handleSmileClick = () => {
    setShowEmojiPicker(!showEmojiPicker);
  };

  const handleEmojiPickerClick = (_, emoji) => {
    setInputValue((comment) => `${comment}${emoji.emoji}`);
  };

  //
  // const handleKeyPress = (evt) => {
  //   if (evt.key === 'Enter' && !evt.shiftKey) {
  //     editModeToggle();
  //     updateComment({
  //       variables: {
  //         id,
  //         content: evt.target.value
  //       }
  //     }).then(({data}) => {
  //       if (!data.updateComment.comment) {
  //         setInputValue(comment.content);
  //         console.log(data.updateComment.errors.fullMessages.join(' '));
  //       }
  //     });
  //     setShowEmojiPicker(false);
  //   }
  // };

  //
  // const removeComment = () => {
  //   destroyComment({
  //     variables: {
  //       id
  //     }
  //   }).then(({data}) => {
  //     if (!data.destroyComment.id) {
  //       console.log(data.destroyComment.errors.fullMessages.join(' '));
  //     }
  //   });
  // };

  return (
    <>
      {/* <div key={id} className="dropdown-item"> */}
      {/* {editable && deletable && (
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
                    onMouseDown={(evt) => {
                      evt.preventDefault();
                    }}
                  >
                    Edit
                  </a>
                </div>
              )}
              <a
                onClick={removeComment}
                onMouseDown={(evt) => {
                  evt.preventDefault();
                }}
              >
                Delete
              </a>
            </div>
          </div>
        )} */}
      {!editMode && (
        <>
          <div
            className="comment"
            onDoubleClick={editable ? editModeToggle : undefined}
          >
            <div className="comment-user">
              <CardUser {...comment.author} />
            </div>
            <div
              className="comment-text"
              style={{wordBreak: 'break-all', whiteSpace: 'pre-line'}}
              //
              // onDoubleClick={editable ? editModeToggle : undefined}
            >
              <Linkify options={linkifyOptions}> {comment.content} </Linkify>
            </div>
          </div>
          {/* <div className="columns">
              <div className="column is-one-fifth">
                <CommentLikes id={comment.id} likes={comment.likes} />
              </div>
              <div className="column is-offset-two-fifths is-two-fifths bottom-content">
                <img src={comment.author.avatar.thumb.url} className="avatar" />
                <span> by {comment.author.email.split('@')[0]}</span>
              </div>
            </div> */}
        </>
      )}
      {editMode && (
        <>
          <TextareaAutosize
            value={inputValue}
            hidden={!editMode}
            onChange={handleChange}
            //
            // onKeyPress={handleKeyPress}
          />
          <a className="has-text-info" onClick={handleSmileClick}>
            <FontAwesomeIcon icon={faSmile} />
          </a>
        </>
      )}
      {/* </div> */}
      {showEmojiPicker && (
        <Picker style={{width: 'auto'}} onEmojiClick={handleEmojiPickerClick} />
      )}
    </>
  );
};

export default Comment;
