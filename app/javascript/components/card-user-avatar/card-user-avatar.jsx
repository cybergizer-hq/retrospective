import React from 'react';
import {getUserInitials} from '../../utils/helpers';
import style from './style.module.less';

const CardUserAvatar = ({avatar, firstName, lastName}) => {
  if (avatar) {
    return <img src={avatar} className={style.avatar} />;
  }

  return (
    <div className={style.avatarText}>
      {getUserInitials(firstName, lastName)}
    </div>
  );
};

export default CardUserAvatar;
