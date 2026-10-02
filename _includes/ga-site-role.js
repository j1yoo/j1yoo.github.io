    // Owner tagging: opening any page once with ?site_role=owner marks this browser as the site owner's,
    // and ?site_role=clear undoes it. Every GA event from a marked browser carries the user property site_role,
    // which the BigQuery view uses to label that browser's events (earlier ones included) as owner.
    (function () {
      var params = new URLSearchParams(location.search);
      var requested = params.get('site_role');
      var role = requested === 'owner' ? 'owner' : requested === 'clear' ? 'cleared' : null;
      try {
        if (role === 'owner') localStorage.setItem('site_role', 'owner');
        if (role === 'cleared') localStorage.removeItem('site_role');
        if (!role) role = localStorage.getItem('site_role');
      } catch (e) {}
      if (requested !== null) {
        // Take the marker out of the address bar, so a copied link cannot mark someone else's browser.
        params.delete('site_role');
        var query = params.toString();
        history.replaceState(history.state, '', location.pathname + (query ? '?' + query : '') + location.hash);
      }
      if (role) gtag('set', 'user_properties', { site_role: role });
    })();
