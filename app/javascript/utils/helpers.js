export const getBigFirstLetter = string => string.toUpperCase().charAt(0);

export const getUserInitials = (name, surname) => {
  return (
    (name ? getBigFirstLetter(name) : '') +
    (surname ? getBigFirstLetter(surname) : '')
  );
};
