import React, {useState, useContext, useEffect} from 'react';
import {useSubscription} from '@apollo/react-hooks';
import ActionItemColumnHeader from './action-item-column-header/action-item-column-header.jsx';
import ActionItem from '../ActionItem';
import UserContext from '../../utils/user_context';
import BoardSlugContext from '../../utils/board_slug_context';
import {
  actionItemAddedSubscription,
  actionItemMovedSubscription,
  actionItemDestroyedSubscription,
  actionItemUpdatedSubscription
} from './operations.gql';
import '../table.css';

const ActionItemColumn = ({creators, users, initItems}) => {
  const user = useContext(UserContext);
  const boardSlug = useContext(BoardSlugContext);
  const [items, setItems] = useState(initItems);
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  useSubscription(actionItemUpdatedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {actionItemUpdated} = data;
      if (actionItemUpdated) {
        updateItem(actionItemUpdated);
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemAddedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {actionItemAdded} = data;
      if (actionItemAdded) {
        setItems(oldItems => [actionItemAdded, ...oldItems]);
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemMovedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {actionItemMoved} = data;
      if (actionItemMoved) {
        setItems(oldItems => [...oldItems, actionItemMoved]);
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemDestroyedSubscription, {
    skip,
    onSubscriptionData: opts => {
      const {data} = opts.subscriptionData;
      const {actionItemDestroyed} = data;
      if (actionItemDestroyed) {
        setItems(oldItems =>
          oldItems.filter(el => el.id !== actionItemDestroyed.id)
        );
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkip(false);
  }, []);

  const updateItem = item => {
    setItems(oldItems => {
      const cardIdIndex = oldItems.findIndex(element => element.id === item.id);
      if (cardIdIndex >= 0) {
        return [
          ...oldItems.slice(0, cardIdIndex),
          item,
          ...oldItems.slice(cardIdIndex + 1)
        ];
      }

      return oldItems;
    });
  };

  return (
    <>
      <ActionItemColumnHeader users={users} />
      {items.map(item => {
        return (
          <ActionItem
            key={item.id}
            assigneeId={item?.assignee?.id}
            id={item.id}
            body={item.body}
            timesMoved={item.times_moved}
            editable={creators.includes(user)}
            deletable={creators.includes(user)}
            assignee={item.assignee?.nickname}
            firstName={item.assignee?.first_name} // TO DO: will be rewritten
            lastName={item.assignee?.last_name} // TO DO: will be rewritten
            avatar={item.assignee_avatar_url}
            users={users}
          />
        );
      })}
    </>
  );
};

export default ActionItemColumn;
