import React from 'react';
import {getUserInitials} from '../../../../utils/helpers';

const CardUser = ({avatar, name, surname, nickname}) => {
  const renderAvatar = (userAvatar, userNickname, userName, userSurname) => {
    if (userAvatar) {
      return (
        <div className="column">
          <img src={userAvatar} className="avatar" />
          <span> {userNickname}</span>
        </div>
      );
    }

    return (
      <div className="column avatar__container">
        <div className="avatar avatar--text">
          {getUserInitials(userName, userSurname)}
        </div>
        <span> {userNickname}</span>
      </div>
    );
  };

  return renderAvatar(avatar, name, nickname, surname);
};

export default CardUser;
