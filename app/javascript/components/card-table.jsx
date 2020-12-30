import React, {useState} from 'react';
import {PrevActionItemColumn} from './prev-action-item-column';
import {CardColumn} from './card-column';
import {ActionItemColumn} from './action-item-column';
import BoardSlugContext from '../utils/board-slug-context';
import UserContext from '../utils/user-context';
import {Provider} from './provider';
import './style.less';

const CardTable = ({
  actionItems,
  cardsByType,
  creators,
  initPrevItems,
  user,
  users
}) => {
  const EMOJIES = ['😡', '😔', '🤗'];

  const [columnClass, setColumnClass] = useState('board-column');

  const [displayPreviousItems, setDisplayPreviousItems] = useState(
    initPrevItems.length > 0
  );

  const togglePreviousItemsOpened = () =>
    setDisplayPreviousItems(!displayPreviousItems);

  const previousActionsEmptyHandler = () => {
    setDisplayPreviousItems(false);
    setColumnClass('column is-one-fourth');
  };

  const generateColumns = (cardTypePairs) => {
    const content = [];
    for (const [index, [columnName, cards]] of Object.entries(
      cardTypePairs
    ).entries()) {
      content.push(
        <div key={`${columnName}_column`} className={columnClass}>
          <CardColumn
            key={columnName}
            kind={columnName}
            smile={EMOJIES[index]}
            initCards={cards}
          />
        </div>
      );
    }

    return content;
  };

  const renderPreviousColumn = () => {
    if (displayPreviousItems) {
      return (
        <div className={columnClass}>
          <PrevActionItemColumn
            handleEmpty={previousActionsEmptyHandler}
            initItems={initPrevItems || []}
            users={users}
            onClickToggle={togglePreviousItemsOpened}
          />
        </div>
      );
    }

    return (
      <div className="side-menu">
        <button
          type="button"
          className="open-button"
          onClick={togglePreviousItemsOpened}
        >
          <svg
            width="5"
            height="10"
            viewBox="0 0 5 10"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M0.5 9L4.5 5L0.5 1"
              stroke="#C6C6C4"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          <svg
            width="5"
            height="10"
            viewBox="0 0 5 10"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M0.5 9L4.5 5L0.5 1"
              stroke="#C6C6C4"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </button>
        <div className="dot">
          <span className="dot__item dot__item--red" />
          <span className="dot__item dot__item--yellow" />
          <span className="dot__item dot__item--yellow" />
          <span className="dot__item dot__item--green" />
          <span className="dot__item dot__item--green" />
          <span className="dot__item dot__item--green" />
        </div>
      </div>
    );
  };

  user.isCreator = creators.includes(user.id);
  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <UserContext.Provider value={user}>
          <div className="board-container">
            {renderPreviousColumn()}
            {generateColumns(cardsByType)}
            <div className={columnClass}>
              <ActionItemColumn initItems={actionItems || []} users={users} />
            </div>
          </div>
        </UserContext.Provider>
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default CardTable;
