# frozen_string_literal: true

module LinksHelper
  def parsed_url(url, name = nil)
    if url.match(%r{^(http|https)?://gist.github.com})
      "<script src=\'#{url}.js\'></script>".html_safe
    else
      link_to(name || url, url)
    end
  end
end
