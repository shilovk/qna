export default function answerHtml(resource) {
  return `
    <div id="answer-${resource.id}">
      ${resource.body}
      <p class="actions">
        <a href="/answers/${resource.id}" data-remote="true">Show</a>
      </p>
      <div class="comments">
        <p>Comments</p>
        <div class="list"></div>
      </div>
    </div>
  `
}
