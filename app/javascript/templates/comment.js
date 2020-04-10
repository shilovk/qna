export default function commentHtml(resource) {
  return `
    <div id="comment-${resource.id}">
      <p class="view">
        ${resource.body}
      </p>
    </div>
  `
}
