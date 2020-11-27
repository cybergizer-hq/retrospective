import React from 'react';

import CardBody from './CardBody';
import CardFooter from './CardFooter';
import CardUser from './card-user/card-user.jsx';
import './Card.css';

const Card = ({
  id,
  body,
  deletable,
  editable,
  author,
  avatar,
  commentsNumber,
  likes,
  type,
  onCommentButtonClick
}) => {
  return (
    <div className="box">
      <CardUser
        avatar={avatar}
        name={author}
        surname={author}
        nickname={author}
      />
      <CardBody id={id} editable={editable} deletable={deletable} body={body} />
      <CardFooter
        id={id}
        author={author}
        avatar={avatar}
        likes={likes}
        type={type}
        commentsNumber={commentsNumber}
        onCommentButtonClick={onCommentButtonClick}
      />
    </div>
  );
};

export default Card;
