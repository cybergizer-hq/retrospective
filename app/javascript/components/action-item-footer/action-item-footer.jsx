import React, {useContext} from 'react';
import {moveActionItemMutation} from './operations.gql';
import {useMutation} from '@apollo/react-hooks';
import {TransitionButton} from '../transition-button';
import BoardSlugContext from '../../utils/board-slug-context';
import './style.less';
const ActionItemFooter = ({id, isReopanable, isCompletable}) => {
  const boardSlug = useContext(BoardSlugContext);
  const [moveActionItem] = useMutation(moveActionItemMutation);
  const handleMoveClick = () => {
    moveActionItem({
      variables: {
        id,
        boardSlug
      }
    }).then(({data}) => {
      if (!data.moveActionItem.actionItem) {
        console.log(data.moveActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  return (
    <div className="action-item__footer">
      {isCompletable && (
        <>
          <TransitionButton
            id={id}
            action="close"
            className="action-item__button"
          />
          <TransitionButton
            id={id}
            action="complete"
            className="action-item__button"
          />
        </>
      )}
      {isReopanable && (
        <TransitionButton
          id={id}
          action="reopen"
          className="action-item__button"
        />
      )}
      {isCompletable && (
        <button
          type="button"
          onClick={() => {
            window.confirm('Are you sure you want to move this ActionItem?') &&
              handleMoveClick();
          }}
        >
          move
        </button>
      )}
    </div>
  );
};

export default ActionItemFooter;
