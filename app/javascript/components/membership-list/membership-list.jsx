import React, {useState, useEffect, useContext} from 'react';
import {useSubscription, useQuery} from '@apollo/react-hooks';
import {
  getMembershipsQuery,
  membershipUpdatedSubscription,
  membershipListUpdatedSubscription,
  membershipDestroyedSubscription
} from './operations.gql';
import User from '../user/user';
import BoardSlugContext from '../../utils/board-slug-context';
import './style.less';

const MembershipList = () => {
  const boardSlug = useContext(BoardSlugContext);
  const [memberships, setMemberships] = useState([]);
  const [skipMutation, setSkipMutation] = useState(true);
  const [skipQuery, setSkipQuery] = useState(false);
  const {loading, data} = useQuery(getMembershipsQuery, {
    variables: {boardSlug},
    skip: skipQuery
  });

  //
  // const calcMembersReady = (users) => {
  //   let readyAmount = 0;
  //   for (const user of users) {
  //     if (user.ready) {
  //       readyAmount++;
  //     }
  //   }

  //   return readyAmount;
  // };
  // const readyMembers = fillerReadyMembers();
  // const notReadyMembers = fillerReadyMembers(false);

  // ! const filterNotReadyUsers = (users) => {
  //   return users.filter((it) => it.ready === false);
  // }

  useEffect(() => {
    if (!loading && Boolean(data)) {
      const {memberships} = data;
      setMemberships(memberships);
      setSkipQuery(true);
    }
  }, [data, loading]);

  useSubscription(membershipDestroyedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipDestroyed} = data;
      if (membershipDestroyed) {
        const {id} = membershipDestroyed;
        setMemberships(memberships.filter((it) => it.id !== id));
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipUpdated} = data;
      if (membershipUpdated) {
        const {id} = membershipUpdated;
        setMemberships((memberships) => {
          const objectIndex = memberships.findIndex((it) => it.id === id);
          return [
            ...memberships.slice(0, objectIndex),
            membershipUpdated,
            ...memberships.slice(objectIndex + 1)
          ];
        });
      }
    },
    variables: {boardSlug}
  });

  useSubscription(membershipListUpdatedSubscription, {
    skip: skipMutation,
    onSubscriptionData: (options) => {
      const {data} = options.subscriptionData;
      const {membershipListUpdated} = data;
      if (membershipListUpdated) {
        setMemberships((memberships) =>
          memberships.concat(membershipListUpdated)
        );
      }
    },
    variables: {boardSlug}
  });

  useEffect(() => {
    setSkipMutation(false);
  }, []);

  // !
  // const usersListComponent = memberships.map((membership) => {
  //   return (
  //     <User
  //       key={membership.id}
  //       shouldDisplayReady
  //       membership={membership}
  //       shouldHandleDelete={false}
  //     />
  //   );
  // });

  const renderMembersList = (users) => {
    const fillerReadyMembers = (isReady = true) => {
      return users.filter((it) => it.ready === isReady);
    };

    const readyMembers = fillerReadyMembers();
    const notReadyMembers = fillerReadyMembers(false);

    if (readyMembers.length === 0) {
      return (
        <div className="users">
          <div className="users__text users__text--not-ready">
            {users.length} people here want to share
          </div>
          <div className="avatars">
            {users.slice(0, 5).map((user) => {
              return (
                <User
                  key={user.id}
                  shouldDisplayReady
                  membership={user}
                  shouldHandleDelete={false}
                />
              );
            })}
          </div>
        </div>
      );
    }

    if (readyMembers.length === users.length) {
      return (
        <div className="users">
          <div className="users__text users__text--ready">
            {users.length} ready
          </div>
          <div className="avatars avatars--ready">
            {readyMembers.slice(0, 5).map((user) => {
              return (
                <User
                  key={user.id}
                  shouldDisplayReady
                  membership={user}
                  shouldHandleDelete={false}
                />
              );
            })}
          </div>
        </div>
      );
    }

    return (
      <div className="users">
        <div className="users__text users__text-ready">
          {readyMembers.length} ready
        </div>
        <div className="avatars avatars--ready">
          {readyMembers.slice(0, 5).map((user) => {
            return (
              <User
                key={user.id}
                shouldDisplayReady
                membership={user}
                shouldHandleDelete={false}
              />
            );
          })}
        </div>
        <div className="users__text users__text--not-ready">
          and waiting for {notReadyMembers.length} more
        </div>
        <div className="avatars avatars--not-ready">
          {notReadyMembers.slice(0, 5).map((user) => {
            return (
              <User
                key={user.id}
                shouldDisplayReady
                membership={user}
                shouldHandleDelete={false}
              />
            );
          })}
        </div>
      </div>
    );
  };
  //
  // return (
  //   <div className="user">
  //     {/* {usersListComponent} */}
  //     {memberships.map((membership) => {
  //       return (
  //         <User
  //           key={membership.id}
  //           shouldDisplayReady
  //           membership={membership}
  //           shouldHandleDelete={false}
  //         />
  //       );
  //     })}
  //   </div>
  // );

  return renderMembersList(memberships);
};

export default MembershipList;
