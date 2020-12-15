const cutUrl = (url) => {
  const match = /(?:https?:\/\/)?([a-z\d\-_]{2,64}\.[a-z]{2,6})/.exec(url);
  if (match) {
    return match[1];
  }

  return url;
};

export const Linkify = require('linkifyjs/react');

export const linkifyOptions = {
  format: cutUrl
};
