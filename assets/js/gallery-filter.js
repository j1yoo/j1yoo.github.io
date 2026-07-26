document.addEventListener('DOMContentLoaded', () => {
  const filters = Array.from(document.querySelectorAll('[data-photo-filter]'));
  const albums = Array.from(document.querySelectorAll('[data-photo-category]'));
  const status = document.getElementById('photo-filter-status');

  if (filters.length === 0 || albums.length === 0) return;

  filters.forEach((button) => {
    button.addEventListener('click', () => {
      const selected = button.dataset.photoFilter;
      let visibleCount = 0;

      albums.forEach((album) => {
        const visible = selected === 'all' || album.dataset.photoCategory === selected;
        album.hidden = !visible;
        if (visible) visibleCount += 1;
      });

      filters.forEach((filter) => {
        const active = filter === button;
        filter.classList.toggle('is-active', active);
        filter.setAttribute('aria-pressed', String(active));
      });

      if (status) {
        status.textContent = `${visibleCount} ${button.dataset.photoFilterLabel} photo albums shown.`;
      }
    });
  });
});
