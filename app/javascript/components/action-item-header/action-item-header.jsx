import React from 'react';

import style from '../prev-action-item-column/style.module.less';

const ActionItemHeader = ({onClickToggle}) => {
  return (
    <>
      <div className={style.header}>
        <h2 className={style.title}>ACTION ITEMS</h2>

        <span className={style.hide} onClick={onClickToggle}>
          hide
        </span>
      </div>

      <hr className={style.lineYellow} />
    </>
  );
};

export default ActionItemHeader;
