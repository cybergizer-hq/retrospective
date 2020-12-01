import React from 'react';
import {getUserInitials} from '../../../../utils/helpers';

const CardUser = ({avatar, fisrtName, lastName, nickname}) => {
  const renderAvatar = (userAvatar, userName, userSurname) => {
    if (userAvatar) {
      return <img src={userAvatar} className="avatar" />;
    }

    return (
      <div className="avatar avatar--text">
        {getUserInitials(userName, userSurname)}
      </div>
    );
  };

  return (
    <div className="column avatar__container">
      {renderAvatar(avatar, fisrtName, lastName)}
      <span className="avatar__nickname"> {nickname}</span>
    </div>
  );
};

export default CardUser;
