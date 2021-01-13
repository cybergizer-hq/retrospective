import React, {useContext} from 'react';
import {useMutation} from '@apollo/react-hooks';
import BoardSlugContext from '../../utils/board-slug-context';
import {
  closeActionItemMutation,
  completeActionItemMutation,
  reopenActionItemMutation
} from './operations.gql';

const TransitionButton = (props) => {
  const {id, action} = props;
  const boardSlug = useContext(BoardSlugContext);

  const [closeActionItem] = useMutation(closeActionItemMutation);
  const [completeActionItem] = useMutation(completeActionItemMutation);
  const [reopenActionItem] = useMutation(reopenActionItemMutation);

  const handleClick = () => {
    switch (action) {
      case 'close':
        closeActionItem({
          variables: {
            id,
            boardSlug
          }
        }).then(({data}) => {
          if (!data.closeActionItem.actionItem) {
            console.log(data.closeActionItem.errors.fullMessages.join(' '));
          }
        });
        break;

      case 'complete':
        completeActionItem({
          variables: {
            id,
            boardSlug
          }
        }).then(({data}) => {
          if (!data.completeActionItem.actionItem) {
            console.log(data.completeActionItem.errors.fullMessages.join(' '));
          }
        });
        break;

      case 'reopen':
        reopenActionItem({
          variables: {
            id,
            boardSlug
          }
        }).then(({data}) => {
          if (!data.reopenActionItem.actionItem) {
            console.log(data.reopenActionItem.errors.fullMessages.join(' '));
          }
        });
        break;
    }
  };

  return (
    <button type="button" onClick={handleClick}>
      {action}
    </button>
  );
};

export default TransitionButton;
