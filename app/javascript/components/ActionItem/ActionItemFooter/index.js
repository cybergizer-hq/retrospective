import React, {useContext} from 'react';
import {moveActionItemMutation} from './operations.gql';
import {useMutation} from '@apollo/react-hooks';
import TransitionButton from '../TransitionButton';
import BoardSlugContext from '../../../utils/board_slug_context';
import './ActionItemFooter.css';
const ActionItemFooter = props => {
  const {id, movable, transitionable, assignee, avatar, timesMoved} = props;
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

  const pickColor = num => {
    switch (true) {
      case [1, 2].includes(num):
        return 'green';
      case [3].includes(num):
        return 'yellow';
      default:
        return 'red';
    }
  };

  const generateChevrons = () => {
    const chevrons = Array.from({length: timesMoved}, (_, index) => (
      <i
        key={index}
        className={`fas fa-chevron-right ${pickColor(timesMoved)}_font`}
      />
    ));
    return chevrons;
  };

  return (
    <div>
      <hr style={{margin: '0.5rem'}} />
      <div className="chevrons">{generateChevrons()}</div>

      {assignee && (
        <div className="columns is-multiline">
          <div className="column is-one-quarter column-assignee">
            <img src={avatar} className="avatar" />
          </div>
          <div className="column column-assignee">
            <p> Assigned to</p>
            <p> {assignee}</p>
          </div>
        </div>
      )}

      {transitionable && transitionable.can_close && (
        <TransitionButton id={id} action="close" />
      )}
      {transitionable && transitionable.can_complete && (
        <TransitionButton id={id} action="complete" />
      )}
      {transitionable && transitionable.can_reopen && (
        <TransitionButton id={id} action="reopen" />
      )}
      {movable && (
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
