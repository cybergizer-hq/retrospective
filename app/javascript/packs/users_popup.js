document.addEventListener('DOMContentLoaded', function() {
  const btn = document.querySelectorAll('.hover-to-open');

  for (const elem of btn) {
    elem.addEventListener('mouseover', function() {
      this.nextElementSibling.style.display = 'block';
    });

    elem.addEventListener('mouseout', function() {
      this.nextElementSibling.style.display = 'none';
    });
  }
});
