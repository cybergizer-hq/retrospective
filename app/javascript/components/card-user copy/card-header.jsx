import React from 'react';
// Import {CardUserAvatar} from '../card-user-avatar';
// Import './style.less';
import {useMutation} from '@apollo/react-hooks';
import style from '../card-body/style.module.less';
import {CardUser} from '../card-user';
import {destroyCardMutation} from './operations.gql';

const CardHeader = ({
  author,
  deletable,
  setShowDropdown,
  showDropdown,
  editMode,
  editable,
  handleEditClick,
  id
}) => {
  const [destroyCard] = useMutation(destroyCardMutation);

  return (
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
  );
};

export default CardHeader;
