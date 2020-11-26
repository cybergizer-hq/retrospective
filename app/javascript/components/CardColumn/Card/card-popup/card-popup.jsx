import React from 'react';
import CommentsDropdown from '../CommentsDropdown';
import Card from '..';
import './card-popup.css';

const CardPopup = ({
  id,
  body,
  deletable,
  editable,
  author,
  avatar,
  commentsNumber,
  likes,
  type,
  onCommentButtonClick,
  comments,
  onClickClosed
}) => {
  const handlePopupClosed = e => {
    if (e.target.classList.contains('card-popup')) {
      onClickClosed();
    }
  };

  return (
    <div className="card-popup" onClick={handlePopupClosed}>
      <div className="card-popup__inner">
        <Card
          editable={editable}
          deletable={deletable}
          body={body}
          id={id}
          author={author}
          avatar={avatar}
          likes={likes}
          type={type}
          commentsNumber={commentsNumber}
          onCommentButtonClick={onCommentButtonClick}
        />
        <CommentsDropdown id={id} comments={comments} />
      </div>
    </div>
  );
};

export default CardPopup;
