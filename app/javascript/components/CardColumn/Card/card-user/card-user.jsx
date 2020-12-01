import React from 'react';
import {getUserInitials} from '../../../../utils/helpers';

const CardUser = ({avatar, fisrtName, lastName, nickname}) => {
  const renderAvatar = (userAvatar, userName, userSurname) => {
    if (userAvatar) {
      return (
        // <div className="column">
        <img src={userAvatar} className="avatar" />
        // <span> {userNickname}</span>
        /* </div> */
      );
    }

    return (
      // <div className="column avatar__container">
      <div className="avatar avatar--text">
        {getUserInitials(userName, userSurname)}
      </div>
      // <span> {userNickname}</span>
      /* </div> */
    );
  };

  return (
    <div className="column avatar__container">
      {renderAvatar(avatar, fisrtName, lastName)}
      <span className="avatar__nickname"> {nickname}</span>
    </div>
    // RenderAvatar(avatar, nickname, fisrtName, lastName);
  );
};

export default CardUser;
