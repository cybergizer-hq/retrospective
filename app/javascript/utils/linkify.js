const cutUrl = (url) => {
  const match = /(?:https?:\/\/)?(?:www\.)?([\w\d-_.]+)/.exec(url);
  if (match) {
    return match[1];
  }

  return url;
};

export const Linkify = require('linkifyjs/react');

export const linkifyOptions = {
  format: cutUrl
};
