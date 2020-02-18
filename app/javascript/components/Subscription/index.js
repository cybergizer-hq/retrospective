import React, {useEffect} from 'react';
import {CardSubscription} from './operations.graphql';

const Subscription = ({subscribeToMore}) => {
  useEffect(() => {
    return subscribeToMore({
      document: CardSubscription,
      updateQuery: (prev, {subscriptionData}) => {
        if (!subscriptionData.data) return prev;

        const newCard = subscriptionData.data.cardAdded;
        // TODO
      }
    });
  });
};
