import React, {useState, useEffect} from 'react';
import Textarea from 'react-textarea-autosize';
import './ActionItemBody.css';
import {
  destroyActionItemMutation,
  updateActionItemMutation
} from './operations.gql';
import {useMutation} from '@apollo/react-hooks';

const ActionItemBody = props => {
  const {assigneeId, editable, deletable, body, users} = props;
  const [inputValue, setInputValue] = useState(body);
  const [editMode, setEditMode] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [actionItemAssignee, setActionItemAssignee] = useState(assigneeId);
  const [destroyActionItem] = useMutation(destroyActionItemMutation);
  const [updateActionItem] = useMutation(updateActionItemMutation);

  useEffect(() => {
    const {body} = props;
    if (!editMode) {
      setInputValue(body);
    }
  }, [props, editMode]);

  const handleDeleteClick = () => {
    const {id} = props;
    hideDropdown();
    destroyActionItem({
      variables: {
        id
      }
    }).then(({data}) => {
      if (!data.destroyActionItem.id) {
        console.log(data.destroyActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  const handleEditClick = () => {
    editModeToggle();
    hideDropdown();
  };

  const editModeToggle = () => {
    setEditMode(editMode => !editMode);
  };

  const handleChange = e => {
    setInputValue(e.target.value);
  };

  const resetTextChanges = () => {
    setInputValue(props.body);
  };

  const handleKeyPress = e => {
    if (e.key === 'Enter' && !e.shiftKey) {
      editModeToggle();
      handleItemEdit(props.id, inputValue);
    }
  };

  const handleItemEdit = (id, body) => {
    updateActionItem({
      variables: {
        id,
        body,
        assigneeId: actionItemAssignee
      }
    }).then(({data}) => {
      if (!data.updateActionItem.actionItem) {
        resetTextChanges();
        console.log(data.updateActionItem.errors.fullMessages.join(' '));
      }
    });
  };

  const toggleDropdown = () => {
    setShowDropdown(isShown => !isShown);
  };

  const hideDropdown = () => {
    setShowDropdown(false);
  };

  const handleSaveClick = () => {
    editModeToggle();
    handleItemEdit(props.id, inputValue);
  };

  return (
    <div>
      {editable && deletable && (
        <div className="dropdown">
          <div
            className="dropdown-btn"
            tabIndex="1"
            onClick={toggleDropdown}
            onBlur={hideDropdown}
          >
            …
          </div>
          <div hidden={!showDropdown} className="dropdown-content">
            {!editMode && (
              <div>
                <a
                  onClick={handleEditClick}
                  onMouseDown={event => {
                    event.preventDefault();
                  }}
                >
                  Edit
                </a>
                <hr style={{margin: '5px 0'}} />
              </div>
            )}
            <a
              onClick={() => {
                window.confirm(
                  'Are you sure you want to delete this ActionItem?'
                ) && handleDeleteClick();
              }}
              onMouseDown={event => {
                event.preventDefault();
              }}
            >
              Delete
            </a>
          </div>
        </div>
      )}
      <div
        className="text"
        hidden={editMode}
        onDoubleClick={editable ? editModeToggle : undefined}
      >
        {body}
      </div>
      {editable && (
        <div hidden={!editMode}>
          <Textarea
            className="input"
            value={inputValue}
            onChange={handleChange}
            onKeyPress={handleKeyPress}
          />
          <div className="columns is-multiline columns-footer">
            <div className="column column-select">
              <select
                className="select"
                value={actionItemAssignee}
                onChange={e => setActionItemAssignee(e.target.value)}
              >
                <option value=" ">Assigned to ...</option>
                {users.map(user => {
                  return (
                    <option key={user.id} value={user.id}>
                      {user.name}
                    </option>
                  );
                })}
              </select>
            </div>
            <div className="column column-btn-save">
              <button
                className="tag is-info button"
                type="button"
                onClick={handleSaveClick}
              >
                Save
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ActionItemBody;
