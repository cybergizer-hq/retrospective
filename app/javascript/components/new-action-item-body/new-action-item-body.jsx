import React, {useState, useContext, useEffect, useRef} from 'react';
import {useMutation} from '@apollo/react-hooks';
import Textarea from 'react-textarea-autosize';
import {addActionItemMutation} from './operations.gql';
import BoardSlugContext from '../../utils/board-slug-context';

const NewActionItemBody = ({users}) => {
  const textInput = useRef();
  const [isOpened, setOpened] = useState(false);
  const [newActionItemBody, setNewActionItemBody] = useState('');
  const [newActionItemAssignee, setNewActionItemAssignee] = useState('');
  const [addActionItem] = useMutation(addActionItemMutation);
  const boardSlug = useContext(BoardSlugContext);

  const toggleOpen = () => setOpened(!isOpened);

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
    <>
      <div className="column-header">
        <h2 className="column-header__title">ACTION ITEMS</h2>
        <div className="column-header__button" onClick={toggleOpen}>
          +
        </div>
      </div>
      {isOpened && (
        <div>
          <form onSubmit={submitHandler}>
            <Textarea
              ref={textInput}
              className="input"
              value={newActionItemBody}
              id="action_item_body`"
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
        </div>
      )}
    </>
  );
};

export default NewActionItemBody;
