import React from 'react';
import {CardUserAvatar} from '../card-user-avatar';
import './style.less';

const CardUser = ({first_name, last_name, nickname, avatar}) => {
  const url = avatar?.thumb?.url;
  return (
    <div className="avatar__container">
      <CardUserAvatar
        avatar={url}
        firstName={first_name}
        lastName={last_name}
      />
      <span className="avatar__nickname">
        {first_name ? `${first_name} ${last_name}` : nickname}
      </span>
    </div>
  );
};

export default CardUser;
