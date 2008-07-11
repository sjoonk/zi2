AutoAdmin.config do |admin|
  # This information is used by the theme to construct a useful
  # header; the first parameter is the full URL of the main site, the
  # second is the displayed name of the site, and the third (optional)
  # parameter is the title for the administration site.
  admin.set_site_info 'http://localhost:3000/', 'example.tld'

  # "Primary Objects" are those for which lists should be directly
  # accessible from the home page.
  admin.primary_objects = %w(post category)

  admin.theme = :django # Optional; this is the default.
end
