import React from 'react';
import Likes from '../Likes';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {faCommentAlt} from '@fortawesome/free-regular-svg-icons';
import './CardFooter.css';

const CardFooter = ({
  id,
  likes,
  type,
  commentsNumber,
  onCommentButtonClick
}) => {
  return (
    <div>
      <hr style={{margin: '0.5rem'}} />
      <div className="columns is-multiline">
        <div className="column is-one-quarter">
          <Likes id={id} likes={likes} type={type} />
        </div>
        <div className="column is-one-quarter">
          <a className="has-text-info" onClick={onCommentButtonClick}>
            <FontAwesomeIcon fixedWidth icon={faCommentAlt} />
          </a>
          <span>{commentsNumber}</span>
        </div>
      </div>
    </div>
  );
};

export default CardFooter;
