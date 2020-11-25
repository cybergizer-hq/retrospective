import React, {useEffect, useState} from 'react';
import Textarea from 'react-textarea-autosize';
import {useMutation} from '@apollo/react-hooks';
import {updateCardMutation, destroyCardMutation} from './operations.gql';

import './CardBody.css';
const CardBody = props => {
  const {id, editable, deletable, body} = props;
  const [inputValue, setInputValue] = useState(body);
  const [editMode, setEditMode] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [editCard] = useMutation(updateCardMutation);
  const [destroyCard] = useMutation(destroyCardMutation);

  useEffect(() => {
    setInputValue(body);
  }, [body, props.body]);

  const handleEditClick = () => {
    editModeToggle();
    setShowDropdown(false);
  };

  const editModeToggle = () => {
    setEditMode(isEdited => !isEdited);
  };

  const handleChange = e => {
    setInputValue(e.target.value);
  };

  const handleKeyPress = e => {
    if (navigator.platform.includes('Mac')) {
      if (e.key === 'Enter' && e.metaKey) {
        handleSaveClick();
      }
    } else if (e.key === 'Enter' && e.ctrlKey) {
      handleSaveClick();
    }
  };

  const handleSaveClick = () => {
    editModeToggle();
    editCard({
      variables: {
        id,
        body: inputValue
      }
    }).then(({data}) => {
      if (!data.updateCard.card) {
        console.log(data.updateCard.errors.fullMessages.join(' '));
      }
    });
  };

  return (
    <div>
      {editable && deletable && (
        <div className="dropdown">
          <div
            className="dropdown-btn"
            tabIndex="1"
            onClick={() => setShowDropdown(!showDropdown)}
            onBlur={() => setShowDropdown(false)}
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
              onClick={() =>
                window.confirm('Are you sure you want to delete this card?') &&
                destroyCard({
                  variables: {
                    id
                  }
                }).then(({data}) => {
                  if (!data.destroyCard.id) {
                    console.log(data.destroyCard.errors.fullMessages.join(' '));
                  }
                })
              }
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
      {editMode && (
        <>
          <Textarea
            autoFocus
            className="input"
            value={inputValue}
            onChange={handleChange}
            onKeyDown={handleKeyPress}
          />
          <div className="btn-add">
            <button
              className="tag is-info button"
              type="button"
              onClick={handleSaveClick}
            >
              Save
            </button>
          </div>
        </>
      )}
    </div>
  );
};

export default CardBody;
