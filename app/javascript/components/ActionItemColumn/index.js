import React, {useState, useContext, useEffect, useCallback} from 'react';
import {useMutation, useSubscription} from '@apollo/react-hooks';
import ActionItem from '../ActionItem';
import UserContext from '../../utils/user_context';
import BoardSlugContext from '../../utils/board_slug_context';
import {
  actionItemAddedSubscription,
  addActionItemMutation,
  actionItemMovedSubscription,
  actionItemDestroyedSubscription,
  actionItemUpdatedSubscription
} from './operations.gql';
import '../table.css';
import Textarea from 'react-textarea-autosize';

const ActionItemColumn = props => {
  const user = useContext(UserContext);
  const boardSlug = useContext(BoardSlugContext);
  const [items, setItems] = useState(props.initItems);
  const [newActionItemBody, setNewActionItemBody] = useState('');
  const [newActionItemAssignee, setNewActionItemAssignee] = useState('');
  const [skip, setSkip] = useState(true); // Workaround for https://github.com/apollographql/react-apollo/issues/3802

  const [addActionItem] = useMutation(addActionItemMutation);

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

  const submitHandler = e => {
    e.preventDefault();
    setOpened(isOpened => !isOpened);
    addActionItem({
      variables: {
        boardSlug,
        assigneeId: newActionItemAssignee,
        body: newActionItemBody
      }
    }).then(({data}) => {
      if (data.addActionItem.actionItem) {
        setNewActionItemBody('');
      } else {
        console.log(data.addActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  const cancelHandler = e => {
    e.preventDefault();
    setOpened(isOpened => !isOpened);
    setNewActionItemBody('');
  };

  const {creators, users} = props;

  const [isOpened, setOpened] = useState(false);
  const handleOpenBox = useCallback(() => {
    setOpened(isOpened => !isOpened);
  }, [setOpened]);

  const handleKeyPress = e => {
    if (navigator.platform.includes('Mac')) {
      if (e.key === 'Enter' && e.metaKey) {
        submitHandler(e);
      }
    } else if (e.key === 'Enter' && e.ctrlKey) {
      submitHandler(e);
    }

    if (e.key === 'Escape') {
      setOpened(isOpened => !isOpened);
      setNewActionItemBody('');
    }
  };

  return (
    <>
      <div className="board-column-title">
        <h2 className="float_left">ACTION ITEMS</h2>
        <div className="float_right card-new" onClick={handleOpenBox}>
          +
        </div>
      </div>
      {isOpened && (
        <div>
          <form onSubmit={submitHandler}>
            <Textarea
              autoFocus
              className="input"
              value={newActionItemBody}
              id="action_item_body`"
              onChange={e => setNewActionItemBody(e.target.value)}
              onKeyDown={handleKeyPress}
            />

            <div className="board-select-column">
              <select
                className="select width_100"
                onChange={e => setNewActionItemAssignee(e.target.value)}
              >
                <option value=" ">Assigned to ...</option>
                {users.map(user => {
                  return (
                    <option key={user.id} value={user.id}>
                      {user.nickname}
                    </option>
                  );
                })}
              </select>
            </div>
            <div className="card-buttons">
              <button
                className="tag is-success button card-add"
                type="submit"
                onSubmit={submitHandler}
              >
                Add
              </button>
              <button
                className="tag button card-cancel"
                type="submit"
                onClick={cancelHandler}
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

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
            assignee={item?.assignee?.nickname}
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
