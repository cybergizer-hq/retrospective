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
  nickname,
  firstName,
  lastName,
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
        name={nickname}
        firstName={firstName}
        lastName={lastName}
        nickname={nickname}
      />
      <CardBody id={id} editable={editable} deletable={deletable} body={body} />
      <CardFooter
        id={id}
        likes={likes}
        type={type}
        commentsNumber={commentsNumber}
        onCommentButtonClick={onCommentButtonClick}
      />
    </div>
  );
};

export default Card;
