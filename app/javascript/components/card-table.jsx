import React, {useState} from 'react';
import PrevActionItemColumn from './PrevActionItemColumn';
import CardColumn from './CardColumn';
import ActionItemColumn from './ActionItemColumn';
import BoardSlugContext from '../utils/board_slug_context';
import UserContext from '../utils/user_context';
import Provider from './Provider';

const CardTable = props => {
  const {
    actionItems,
    cardsByType,
    creators,
    initPrevItems,
    user,
    users
  } = props;

  const [columnClass, setColumnClass] = useState(
    'column board-column light-gray'
  );

  const [displayPrevItems, setDisplayPrevItems] = useState(
    initPrevItems.length > 0
  );

  const prevActionsEmptyHandler = () => {
    setDisplayPrevItems(false);
    setColumnClass('column is-one-fourth');
  };

  const generateColumns = cardTypePairs => {
    const content = [];
    for (const [columnName, cards] of Object.entries(cardTypePairs)) {
      content.push(
        <div key={`${columnName}_column`} className={columnClass}>
          <CardColumn key={columnName} kind={columnName} initCards={cards} />
        </div>
      );
    }

    return content;
  };
  // Debugger;

  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <UserContext.Provider value={user}>
          <div className="board-columns">
            {displayPrevItems ? (
              <div className={columnClass}>
                <PrevActionItemColumn
                  creators={creators}
                  handleEmpty={prevActionsEmptyHandler}
                  initItems={initPrevItems || []}
                />
              </div>
            ) : null}

            {generateColumns(cardsByType)}

            <div className={columnClass}>
              <ActionItemColumn
                creators={creators}
                initItems={actionItems || []}
                users={users}
              />
            </div>
          </div>
        </UserContext.Provider>
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default CardTable;
