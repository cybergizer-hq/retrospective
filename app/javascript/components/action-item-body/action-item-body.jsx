import React, {useState, useEffect} from 'react';
import Textarea from 'react-textarea-autosize';
import './style.less';
import {
  destroyActionItemMutation,
  updateActionItemMutation
} from './operations.gql';
import {useMutation} from '@apollo/react-hooks';
import {Linkify, linkifyOptions} from '../../utils/linkify';
import {CardUser} from '../card-user';

const ActionItemBody = (props) => {
  const {assignee, editable, deletable, body, users, timesMoved} = props;
  const [inputValue, setInputValue] = useState(body);
  const [editMode, setEditMode] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [actionItemAssignee, setActionItemAssignee] = useState(assignee?.id);
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
    setEditMode(!editMode);
  };

  const handleChange = (evt) => {
    setInputValue(evt.target.value);
  };

  const resetTextChanges = () => {
    setInputValue(props.body);
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        editModeToggle();
        handleItemEdit(props.id, inputValue);
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
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
    setShowDropdown(!showDropdown);
  };

  const hideDropdown = () => {
    setShowDropdown(false);
  };

  const handleSaveClick = () => {
    editModeToggle();
    handleItemEdit(props.id, inputValue);
  };

  const pickColor = (number) => {
    switch (true) {
      case [1, 2].includes(number):
        return 'green';
      case [3].includes(number):
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
      <div className="card-top action-item-top">
        {
          assignee && <CardUser {...assignee} />
          // Заменить на author после того как он появится
        }

        <div className="card-chevrons">{generateChevrons()}</div>

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
                    onMouseDown={(evt) => {
                      evt.preventDefault();
                    }}
                  >
                    Edit
                  </a>
                </div>
              )}
              <a
                onClick={() => {
                  window.confirm(
                    'Are you sure you want to delete this ActionItem?'
                  ) && handleDeleteClick();
                }}
                onMouseDown={(evt) => {
                  evt.preventDefault();
                }}
              >
                Delete
              </a>
            </div>
          </div>
        )}
      </div>

      <div
        className="card-text"
        hidden={editMode}
        onDoubleClick={editable ? editModeToggle : undefined}
      >
        <Linkify options={linkifyOptions}> {body}</Linkify>
      </div>
      {editable && (
        <div hidden={!editMode}>
          <Textarea
            autoFocus
            className="input"
            value={inputValue}
            onChange={handleChange}
            onKeyDown={handleKeyPress}
          />
          <div className="columns is-multiline columns-footer">
            <div className="column column-select">
              <select
                className="select"
                value={actionItemAssignee}
                onChange={(evt) => setActionItemAssignee(evt.target.value)}
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
