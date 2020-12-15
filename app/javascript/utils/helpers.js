export const getBigFirstLetter = (string) => string.toUpperCase().charAt(0);

export const getUserInitials = (name, surname) => {
  return (
    (name ? getBigFirstLetter(name) : '') +
    (surname ? getBigFirstLetter(surname) : '')
  );
};

export const cutUrl = (url) => {
  const match = /(?:https?:\/\/)?([a-z\d\-_]{2,64}\.[a-z]{2,6})/.exec(url);
  if (match) {
    return match[1];
  }

  return url;
};
