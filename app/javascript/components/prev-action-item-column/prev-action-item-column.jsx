import React, {useState, useContext, useEffect} from 'react';
import {ActionItem} from '../action-item';
import {
  actionItemMovedSubscription,
  actionItemUpdatedSubscription
} from './operations.gql';
import {useSubscription} from '@apollo/react-hooks';
import BoardSlugContext from '../../utils/board-slug-context';
import style from './style.module.less';

const PreviousActionItemColumn = (props) => {
  const {users, handleEmpty, initItems, onClickToggle} = props;

  const [actionItems, setActionItems] = useState(initItems);
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  const boardSlug = useContext(BoardSlugContext);

  useSubscription(actionItemMovedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemMoved} = data;
      if (actionItemMoved) {
        setActionItems((oldItems) => {
          const newItems = oldItems.filter(
            (element) => element.id !== actionItemMoved.id
          );
          if (newItems.length === 0) {
            handleEmpty();
          }

          return newItems;
        });
      }
    },
    variables: {boardSlug}
  });

  useSubscription(actionItemUpdatedSubscription, {
    skip,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {actionItemUpdated} = data;
      if (actionItemUpdated) {
        setActionItems((oldItems) => {
          const cardIdIndex = oldItems.findIndex(
            (element) => element.id === actionItemUpdated.id
          );
          if (cardIdIndex >= 0) {
            return [
              ...oldItems.slice(0, cardIdIndex),
              actionItemUpdated,
              ...oldItems.slice(cardIdIndex + 1)
            ];
          }

          return oldItems;
        });
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkip(false);
  }, []);

  return (
    <>
      <div className={style.header}>
        <h2 className={style.title}>Past Actions</h2>
        <a href="/boards/my">See more</a>
        <span className={style.hide} onClick={onClickToggle}>
          hide
        </span>
      </div>
      <hr className={style.lineGradient} />
      {actionItems.map((item) => (
        <ActionItem key={item.id} isPrevious users={users} {...item} />
      ))}
    </>
  );
};

export default PreviousActionItemColumn;
