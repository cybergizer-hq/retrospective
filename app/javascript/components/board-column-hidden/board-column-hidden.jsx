import React from 'react';

const BoardColumnHidden = ({toggleOpen}) => {
  return (
    <div className="side-menu">
      <button type="button" className="open-button" onClick={toggleOpen}>
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

export default BoardColumnHidden;
