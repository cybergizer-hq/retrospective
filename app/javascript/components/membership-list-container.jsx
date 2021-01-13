import React from 'react';
import {MembershipList} from './membership-list';
import {Provider} from './provider';
import BoardSlugContext from '../utils/board-slug-context';

const MembershipListContainer = () => {
  return (
    <Provider>
      <BoardSlugContext.Provider value={window.location.pathname.split('/')[2]}>
        <MembershipList />
      </BoardSlugContext.Provider>
    </Provider>
  );
};

export default MembershipListContainer;
