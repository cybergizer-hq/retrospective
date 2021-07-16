import React, {useState} from 'react';
import {PrevActionItemColumn} from './prev-action-item-column';
import {CardColumn} from './card-column';
import {ActionItemColumn} from './action-item-column';
import BoardSlugContext from '../utils/board-slug-context';
import UserContext from '../utils/user-context';
import {Provider} from './provider';
import './style.less';
import {BoardColumnHidden} from './board-column-hidden';

const CardTable = ({
  actionItems,
  cardsByType,
  creators,
  initPrevItems,
  user,
  users
}) => {
  const EMOJIES = ['😡', '😔', '🤗'];

  const [isPreviousItemsOpen, setIsPreviousItemsOpen] = useState(
    initPrevItems.length > 0
  );
  const [isActionItemsOpen, setIsActionItemsOpen] = useState(true);

  const togglePreviousItemsOpened = () =>
    setIsPreviousItemsOpen(!isPreviousItemsOpen);

  const toggleActionItemsOpened = () => {
    setIsActionItemsOpen(!isActionItemsOpen);
  };

  const previousActionsEmptyHandler = () => {
    setIsPreviousItemsOpen(false);
  };

  const generateColumns = (cardTypePairs) => {
    const content = [];
    for (const [index, [columnName, cards]] of Object.entries(
      cardTypePairs
    ).entries()) {
      content.push(
        <div key={`${columnName}_column`} className="board-column column">
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

  user.isCreator = creators.includes(user.id);
  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <UserContext.Provider value={user}>
          <div className="board-container">
            {isPreviousItemsOpen ? (
              <div className="board-column column">
                <PrevActionItemColumn
                  handleEmpty={previousActionsEmptyHandler}
                  initItems={initPrevItems || []}
                  users={users}
                  onClickToggle={togglePreviousItemsOpened}
                />
              </div>
            ) : (
              <BoardColumnHidden toggleOpen={togglePreviousItemsOpened} />
            )}
            {generateColumns(cardsByType)}
            {isActionItemsOpen ? (
              <div className="board-column column">
                <ActionItemColumn
                  initItems={actionItems || []}
                  users={users}
                  onClickToggle={toggleActionItemsOpened}
                />
              </div>
            ) : (
              <BoardColumnHidden toggleOpen={toggleActionItemsOpened} />
            )}
          </div>
        </UserContext.Provider>
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default CardTable;
