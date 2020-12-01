// Const ASSIGNEE = {
//   id: 1,
//   email: "tu1@mail.com",
//   firstName: "tu1@mail",
//   lastName: "petroff",
//   nickname: "petr",
//   avatar: null,
//   // avatar: "/assets/default_avatar.jpg",
// }

export const USER = {
  id: 1,
  email: 'tu1@mail.com',
  firstName: 'tu1@mail',
  lastName: 'ivanoff',
  nickname: 'ivan',
  avatar: null
  // Avatar: "/assets/default_avatar.jpg",
};

export const ACTION_ITEMS = [
  {
    id: 7,
    body: `text`,
    timesMoved: 1,
    status: `pending`,
    assignee: USER
  },
  {
    id: 8,
    body: `text`,
    timesMoved: 5,
    status: `pending`,
    assignee: USER
  }
];

export const BOARD = {
  columnNames: ['mad', 'sad', 'glad'],
  created: '2020-11-30T11:09:48.327Z',
  id: 13,
  previousBoardId: 6,
  private: false,
  slug: '8-o_YHkmY4', /// wtf?
  title: '30-11-2020',
  updated: '2020-11-30T11:09:48.327Z',
  usersAmount: 2
};

export const CARD = {
  author: USER,
  body: 'some text',
  comments: [],
  id: 89,
  kind: 'sad',
  likes: 0
};

export const CARDS_BY_TYPE = {
  mad: [CARD, CARD, CARD],
  sad: [CARD],
  glad: []
};

export const CREATORS = [USER.email]; // ????

export const PREVIOUS_ITEMS = [
  {
    id: 111,
    body: `text`,
    timesMoved: 1,
    status: `pending`,
    assignee: USER
  },
  {
    id: 121,
    body: `text`,
    timesMoved: 1,
    status: `pending`,
    assignee: USER
  }
];

export const BOARD_USER = [USER.email];

export const BOARD_USERS = [
  USER,
  {
    id: 3,
    email: 'tu2@mail.com',
    firstName: 'tu1@mail',
    lastName: 'ivanoff',
    nickname: 'ivan',
    avatar: null
  }
];

// ___________________________\\
