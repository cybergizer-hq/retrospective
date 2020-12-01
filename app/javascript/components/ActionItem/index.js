import React from 'react';

import ActionItemBody from './ActionItemBody';
import ActionItemFooter from './ActionItemFooter';
import './ActionItem.css';
import CardUser from '../CardColumn/Card/card-user/card-user.jsx';

class ActionItem extends React.Component {
  pickColor = () => {
    switch (this.props.status) {
      case 'done':
        return 'green';
      case 'closed':
        return 'red';
      default:
        return null;
    }
  };

  render() {
    const {
      id,
      body,
      timesMoved,
      deletable,
      editable,
      movable,
      transitionable,
      assignee,
      assigneeId,
      avatar,
      users,
      lastName,
      firstName
    } = this.props;
    const footerNotEmpty =
      movable || transitionable || timesMoved !== 0 || assignee !== null;

    return (
      <div className={`box ${this.pickColor()}_bg`}>
        {assignee && (
          <CardUser
            avatar={avatar}
            nickname={assignee}
            firstName={firstName}
            lastName={lastName}
          />
        )}

        <ActionItemBody
          id={id}
          assigneeId={assigneeId}
          editable={editable}
          deletable={deletable}
          body={body}
          users={users}
        />
        {footerNotEmpty && (
          <ActionItemFooter
            id={id}
            timesMoved={timesMoved}
            movable={movable}
            transitionable={transitionable}
            assignee={assignee}
          />
        )}
      </div>
    );
  }
}

export default ActionItem;
