import React, {useState, useContext, useEffect, useRef} from 'react';
import {useMutation} from '@apollo/react-hooks';
import Textarea from 'react-textarea-autosize';
import {addActionItemMutation} from './operations.gql';
import BoardSlugContext from '../../utils/board-slug-context';
// Import style from '../prev-action-item-column/style.module.less';

const NewActionItem = ({users}) => {
  const textInput = useRef();
  const [isOpened, setOpened] = useState(false);
  const [newActionItemBody, setNewActionItemBody] = useState('');
  const [newActionItemAssignee, setNewActionItemAssignee] = useState('');
  const [addActionItem] = useMutation(addActionItemMutation);
  const boardSlug = useContext(BoardSlugContext);

  // Const toggleOpen = () => setOpened(!isOpened);

  useEffect(() => {
    if (isOpened) {
      textInput.current.focus();
    }
  }, [isOpened]);

  const cancelHandler = (evt) => {
    evt.preventDefault();
    setOpened(!isOpened);
    setNewActionItemBody('');
  };

  const submitHandler = async (evt) => {
    evt.preventDefault();

    const {data} = await addActionItem({
      variables: {
        boardSlug,
        assigneeId: newActionItemAssignee,
        body: newActionItemBody
      }
    });
    if (data.addActionItem.actionItem) {
      setNewActionItemBody('');
    } else {
      console.log(data.addActionItem.errors.fullMessages.join(' '));
    }
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        submitHandler(evt);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
      submitHandler(evt);
    }

    if (evt.key === 'Escape') {
      setOpened(!isOpened);
      setNewActionItemBody('');
    }
  };

  return (
    <form onSubmit={submitHandler}>
      <Textarea
        ref={textInput}
        className="input"
        value={newActionItemBody}
        id="action_item_body"
        onChange={(evt) => setNewActionItemBody(evt.target.value)}
        onKeyDown={handleKeyPress}
      />

      <div className="board-select-column">
        <select
          className="select width_100"
          onChange={(evt) => setNewActionItemAssignee(evt.target.value)}
        >
          <option value=" ">Assigned to ...</option>
          {users.map((user) => {
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
  );
};

export default NewActionItem;
