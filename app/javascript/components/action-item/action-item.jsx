import React, {useContext} from 'react';
import {ActionItemBody} from '../action-item-body';
import {ActionItemFooter} from '../action-item-footer';
import UserContext from '../../utils/user-context';
import style from './style.module.less';
import styleCard from '../card/style.module.less';

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
          return style.green;
        case 1:
          return style.green;
        case 2:
          return style.green;
        case 3:
          return style.yellow;
        default:
          return style.red;
      }
    } else {
      return ``;
    }
  };

  const currentUser = useContext(UserContext);
  const isStatusPending = status === 'pending';
  return (
    <div className={`${pickColor(times_moved, isPrevious)} ${styleCard.card}`}>
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
