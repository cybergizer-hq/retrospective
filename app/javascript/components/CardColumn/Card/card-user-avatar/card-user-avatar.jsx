import React from 'react';
import {getUserInitials} from '../../../../utils/helpers';

const CardUserAvatar = ({avatar, firstName, lastName}) => {
  if (avatar) {
    return <img src={avatar} className="avatar" />;
  }

  return (
    <div className="avatar avatar--text">
      {getUserInitials(firstName, lastName)}
    </div>
  );
};

export default CardUserAvatar;
