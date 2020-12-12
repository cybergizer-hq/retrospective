import React, {useContext, useMemo} from 'react';
import UserContext from '../../../utils/user_context';
import CardBody from './CardBody';
import CardFooter from './CardFooter';
import CardUser from './card-user/card-user';
import './Card.css';

const Card = ({
  id,
  body,
  author,
  comments,
  likes,
  type,
  onCommentButtonClick
}) => {
  const {email} = author;

  const user = useContext(UserContext);

  const isTemporaryId = (id) => {
    return id.toString().startsWith('tmp-');
  };

  const editable = useMemo(() => !isTemporaryId(id) && user === email, [id]);

  return (
    <div className="box">
      <CardUser {...author} />
      <CardBody id={id} editable={editable} body={body} />
      <CardFooter
        id={id}
        likes={likes}
        type={type}
        commentsNumber={comments.length}
        onCommentButtonClick={onCommentButtonClick}
      />
    </div>
  );
};

export default Card;
