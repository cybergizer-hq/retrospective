import React from 'react';
import CardUserAvatar from '../card-user-avatar/card-user-avatar';

const CardUser = ({first_name, last_name, nickname, avatar}) => {
  const url = avatar?.thumb?.url;
  return (
    <div className="column avatar__container">
      <CardUserAvatar
        avatar={url}
        firstName={first_name}
        lastName={last_name}
      />
      <span className="avatar__nickname"> {nickname}</span>
    </div>
  );
};

export default CardUser;
