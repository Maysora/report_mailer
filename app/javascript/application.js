// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// Whenever render is called, we want to see if there is a rails _anchor query parameter,
// if so, we want to transform it into a proper hash and then try to scroll to it. Find
// the associated server side code in a custom "redirect_to" method.
addEventListener('turbo:load', (event) => {
  const url = new URL(location.href)
  const urlParams = new URLSearchParams(url.search)

  // _anchor is a special query parameter added by a custom rails redirect_to
  const anchorParam = urlParams.get('_anchor')

  // only continue if we found a rails anchor
  if (anchorParam) {
    urlParams.delete('_anchor')

    // update the hash to be the custom anchor
    url.hash = anchorParam

    // create a new URL with the new parameters
    let searchString = ''
    if (urlParams.size > 0) {
      searchString = '?' + urlParams.toString()
    }

    // the new relative path
    const newPath = url.pathname + searchString + url.hash

    // rewrite the history to remove the custom _anchor query parameter and include the hash
    history.replaceState({}, document.title, newPath)
  }

  // scroll to the anchor
  if (location.hash) {
    const anchorId = location.hash.slice(1)
    const element = document.getElementById(anchorId)
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'center' })
      element.classList.add('anchor-active')
    }
  }

})
