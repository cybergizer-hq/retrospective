import React, {useState, useContext, useEffect} from 'react';
import {useSubscription} from '@apollo/react-hooks';
import NewActionItemBody from '../new-action-item-body/new-action-item-body';
import ActionItem from '../ActionItem';
import BoardSlugContext from '../../utils/board_slug_context';
// Import UserContext from '../../utils/user-context';
import {
  actionItemAddedSubscription,
  actionItemMovedSubscription,
  actionItemDestroyedSubscription,
  actionItemUpdatedSubscription
} from './operations.gql';
import '../table.css';

const ActionItemColumn = ({users, initItems}) => {
  const boardSlug = useContext(BoardSlugContext);
  const [items, setItems] = useState(initItems);
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  useSubscription(actionItemUpdatedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemUpdated} = data;
      if (actionItemUpdated) {
        updateItem(actionItemUpdated);
      }
    },
    variables: {boardSlug}
  });

  // Let firstObj = myChartArray.find(item => item.Key === 'FirstObj');

  const checkIsItemAddedById = (array, addedItem) => {
    array.find((it) => it.id.toString() === addedItem.id).toString();
  };

  useSubscription(actionItemAddedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemAdded} = data;
      if (actionItemAdded) {
        if (!checkIsItemAddedById(items, actionItemAdded)) {
          setItems((oldItems) => [actionItemAdded, ...oldItems]);
        }
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemMovedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemMoved} = data;
      if (actionItemMoved) {
        setItems((oldItems) => [actionItemMoved, ...oldItems]);
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemDestroyedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemDestroyed} = data;
      if (actionItemDestroyed) {
        setItems((oldItems) =>
          oldItems.filter((element) => element.id !== actionItemDestroyed.id)
        );
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkip(false);
  }, []);

  const updateItem = (item) => {
    setItems((oldItems) => {
      const cardIdIndex = oldItems.findIndex(
        (element) => element.id === item.id
      );
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
      <NewActionItemBody
        users={users}
        onItemAdded={(itemAdded) => {
          setItems((items) => [itemAdded, ...items]);
        }}
        onGetNewItemId={(itemMockId, itemId) => {
          setItems((items) => {
            items[items.findIndex((it) => it.id === itemMockId)].id = itemId;
            return items;
          });
        }}
      />
      {items.map((item) => {
        return <ActionItem key={item.id} {...item} users={users} />;
      })}
    </>
  );
};

export default ActionItemColumn;
