import React, {useState} from 'react';
import {useMutation} from '@apollo/react-hooks';
import {destroyMembershipMutation} from './operations.gql';
import {getUserInitials} from '../../utils/helpers';
import './style.less';

const User = ({
  membership: {
    ready,
    id,
    user: {email, avatar, lastName, firstName}
  },
  shouldDisplayReady,
  shouldHandleDelete
}) => {
  const [style, setStyle] = useState({});
  const [destroyMember] = useMutation(destroyMembershipMutation);
  const deleteUser = () => {
    destroyMember({
      variables: {
        id
      }
    }).then(({data}) => {
      if (data.destroyMembership.id) {
        if (shouldHandleDelete) {
          setStyle({display: 'none'});
        }
      } else {
        console.log(data.destroyMembership.errors.fullMessages.join(' '));
      }
    });
  };

  const renderBoardAvatar = (userAvatar, userName, userSurname) => {
    if (userAvatar) {
      return (
        <img
          src={avatar.thumb.url}
          className={`${shouldDisplayReady && ready ? 'isReady' : ''} avatar`}
          alt={email}
          title={email}
        />
      );
    }

    return (
      <div
        className={`${
          shouldDisplayReady && ready ? 'isReady' : ''
        } avatar avatar--text`}
      >
        {getUserInitials(userName, userSurname)}
      </div>
    );
  };

  return (
    <div key={email} style={style} className="avatar-wrapper">
      {renderBoardAvatar(avatar.thumb.url, firstName, lastName)}
      <div className="avatar__tooltip">
        {firstName} {lastName}
      </div>
      {shouldHandleDelete && (
        <a className="delete is-small" onClick={deleteUser} />
      )}
    </div>
  );
};

export default User;
