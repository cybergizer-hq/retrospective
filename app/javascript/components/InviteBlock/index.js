import React, {useState, useEffect, useContext} from 'react';
import Select from 'react-select';
import {useMutation, useQuery, useLazyQuery} from '@apollo/react-hooks';
import {
  getMembershipsQuery,
  getSuggestionsQuery,
  inviteMembersMutation
} from './operations.gql';
import User from '../User';
import BoardSlugContext from '../../utils/board_slug_context';

const InviteBlock = () => {
  const boardSlug = useContext(BoardSlugContext);
  const [memberships, setMemberships] = useState([]);
  const [selectedOption, setSelectedOption] = useState(null);
  const [options, setOptions] = useState([]);
  const [skipQuery, setSkipQuery] = useState(false);
  const {loading: membershipLoading, data: membershipData} = useQuery(
    getMembershipsQuery,
    {
      variables: {boardSlug},
      skip: skipQuery
    }
  );

  const [getSuggestions] = useLazyQuery(getSuggestionsQuery, {
    onCompleted: ({suggestions}) => {
      const suggestionsArray = [
        ...new Set(suggestions.users.concat(suggestions.teams))
      ];
      const optionsArray = suggestionsArray.map(function(a) {
        return {
          value: a,
          label: a
        };
      });
      setOptions(optionsArray);
    }
  });

  useEffect(() => {
    if (!membershipLoading && Boolean(membershipData)) {
      const {memberships} = membershipData;
      setMemberships(memberships);
      setSkipQuery(true);
    }
  }, [membershipData, membershipLoading]);

  const [inviteMembers] = useMutation(inviteMembersMutation);

  const handleSubmit = e => {
    e.preventDefault();
    inviteMembers({
      variables: {
        email: selectedOption.map(a => a.value).toString(),
        boardSlug
      }
    }).then(({data}) => {
      if (data.inviteMembers.memberships) {
        const {memberships} = data.inviteMembers;
        setMemberships(oldMemberships => [
          ...new Set(oldMemberships.concat(memberships))
        ]);
        setSelectedOption(null);
      } else {
        console.log(data.inviteMembers.errors.fullMessages.join(' '));
        setSelectedOption(null);
      }
    });
  };

  const handleChange = selectedOption => {
    setSelectedOption(selectedOption);
  };

  const usersListComponent = memberships.map(membership => {
    return (
      <User
        key={membership.id}
        shouldHandleDelete
        membership={membership}
        shouldDisplayReady={false}
      />
    );
  });
  const components = {
    DropdownIndicator: null
  };
  return (
    <>
      <p>users on this board:</p>
      <div className="tags">{usersListComponent}</div>
      <form onSubmit={handleSubmit}>
        <Select
          isMulti
          value={selectedOption}
          options={options}
          placeholder="Enter e-mail or team name..."
          components={components}
          onChange={handleChange}
          onInputChange={e => {
            if (e.length >= 3) getSuggestions({variables: {autocomplete: e}});
          }}
        />
        <input type="submit" value="Invite" />
      </form>
    </>
  );
};

export default InviteBlock;
