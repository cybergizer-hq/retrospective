import React, {useEffect, useState} from 'react';
import Textarea from 'react-textarea-autosize';
import {useMutation} from '@apollo/react-hooks';
import {updateCardMutation, destroyCardMutation} from './operations.gql';
import {CardUser} from '../card-user';
import style from './style.module.less';
import styleButton from '../../less/button.module.less';
import {Linkify, linkifyOptions} from '../../utils/linkify';

const CardBody = ({author, id, editable, body, deletable}) => {
  const [inputValue, setInputValue] = useState(body);
  const [editMode, setEditMode] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [editCard] = useMutation(updateCardMutation);
  const [destroyCard] = useMutation(destroyCardMutation);

  useEffect(() => {
    setInputValue(body);
  }, [body]);

  const handleEditClick = () => {
    editModeToggle();
    setShowDropdown(false);
  };

  const editModeToggle = () => {
    setEditMode((isEdited) => !isEdited);
  };

  const handleChange = (evt) => {
    setInputValue(evt.target.value);
  };

  const handleKeyPress = (evt) => {
    if (navigator.platform.includes('Mac')) {
      if (evt.key === 'Enter' && evt.metaKey) {
        handleSaveClick();
      }
    } else if (evt.key === 'Enter' && evt.ctrlKey) {
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

  const handleCancel = (evt) => {
    evt.preventDefault();
    setEditMode(false);
    setInputValue(body);
  };

  return (
    <div className={style.cardBody}>
      <div className={style.top}>
        <CardUser {...author} />

        {deletable && (
          <div className={style.dropdown}>
            <div
              className={style.dropdownButton}
              tabIndex="1"
              onClick={() => setShowDropdown(!showDropdown)}
              onBlur={() => setShowDropdown(false)}
            >
              …
            </div>
            <div hidden={!showDropdown} className={style.dropdownContent}>
              {!editMode && editable && (
                <div
                  className={style.dropdownItem}
                  onClick={handleEditClick}
                  onMouseDown={(event) => {
                    event.preventDefault();
                  }}
                >
                  Edit
                </div>
              )}
              <div
                className={style.dropdownItem}
                onClick={() =>
                  window.confirm(
                    'Are you sure you want to delete this card?'
                  ) &&
                  destroyCard({
                    variables: {
                      id
                    }
                  }).then(({data}) => {
                    if (!data.destroyCard.id) {
                      console.log(
                        data.destroyCard.errors.fullMessages.join(' ')
                      );
                    }
                  })
                }
                onMouseDown={(event) => {
                  event.preventDefault();
                }}
              >
                Delete
              </div>
            </div>
          </div>
        )}
      </div>
      <div
        className={style.cardText}
        hidden={editMode}
        onDoubleClick={editable ? editModeToggle : undefined}
      >
        <Linkify options={linkifyOptions}> {body} </Linkify>
      </div>
      {editMode && (
        <>
          <Textarea
            autoFocus
            className={style.textarea}
            value={inputValue}
            onChange={handleChange}
            onKeyDown={handleKeyPress}
          />
          <div className={styleButton.buttons}>
            <button
              className={styleButton.buttonCancel}
              type="button"
              onClick={handleCancel}
            >
              cancel
            </button>
            <button
              className={styleButton.buttonPost}
              type="button"
              onClick={handleSaveClick}
            >
              post
            </button>
          </div>
        </>
      )}
    </div>
  );
};

export default CardBody;
