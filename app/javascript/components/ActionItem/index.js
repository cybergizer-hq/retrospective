import React from 'react';

import ActionItemBody from './ActionItemBody';
import ActionItemFooter from './ActionItemFooter';
import './ActionItem.css';

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
      users
    } = this.props;
    const footerNotEmpty =
      movable || transitionable || timesMoved !== 0 || assignee !== null;

    return (
      <div className={`box ${this.pickColor()}_bg`}>
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
            avatar={avatar}
          />
        )}
      </div>
    );
  }
}

export default ActionItem;
