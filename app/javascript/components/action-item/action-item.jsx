import React, {useState, useContext} from 'react';
import {ActionItemBody} from '../action-item-body';
import {ActionItemFooter} from '../action-item-footer';
import './style.less';
import UserContext from '../../utils/user-context';
// ! import {CardUser} from '../card-user';

const ActionItem = ({
  id,
  body,
  status,
  times_moved,
  assignee,
  users,
  isPrevious,
  author_id
}) => {
  //
  //  const pickColor = (cardStatus) => {
  //   switch (cardStatus) {
  //     case 'done':
  //       return 'green';
  //     case 'closed':
  //       return 'red';
  //     default:
  //       return null;
  //   }
  // };

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
  const [isAuthor] = useState(currentUser.id === author_id);

  return (
    <div className={`${pickColor(times_moved, isPrevious)} card`}>
      {/* {assignee && <CardUser {...assignee} />} */}

      <ActionItemBody
        id={id}
        assignee={assignee}
        // ! assigneeId={assignee?.id}
        editable={isAuthor || currentUser.isCreator}
        deletable={isAuthor || currentUser.isCreator}
        body={body}
        users={users}
        timesMoved={times_moved}
      />
      {isPrevious && (
        <ActionItemFooter
          id={id}
          isReopanable={(isAuthor || currentUser.isCreator) && !isStatusPending}
          isCompletable={(isAuthor || currentUser.isCreator) && isStatusPending}
        />
      )}
    </div>
  );
};

export default ActionItem;
