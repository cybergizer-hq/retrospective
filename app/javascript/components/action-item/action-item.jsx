import React, {useContext} from 'react';
import {ActionItemBody} from '../action-item-body';
import {ActionItemFooter} from '../action-item-footer';
import './style.less';
import UserContext from '../../utils/user-context';

const ActionItem = ({
  id,
  body,
  status,
  times_moved,
  assignee,
  users,
  isPrevious
}) => {
  const pickColor = (number, isColor) => {
    if (isColor) {
      switch (number) {
        case 0:
          return 'green';
        case 1:
          return 'green';
        case 2:
          return 'green';
        case 3:
          return 'yellow';
        default:
          return 'red';
      }
    } else {
      return ``;
    }
  };

  const currentUser = useContext(UserContext);
  const isStatusPending = status === 'pending';
  return (
    <div className={`${pickColor(times_moved, isPrevious)} card`}>
      <ActionItemBody
        id={id}
        assignee={assignee}
        editable={currentUser.isCreator}
        deletable={currentUser.isCreator}
        body={body}
        users={users}
        timesMoved={times_moved}
      />
      {isPrevious && (
        <ActionItemFooter
          id={id}
          isReopanable={currentUser.isCreator && !isStatusPending}
          isCompletable={currentUser.isCreator && isStatusPending}
        />
      )}
    </div>
  );
};

export default ActionItem;
