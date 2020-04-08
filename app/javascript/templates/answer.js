export default function answerHtml(answer) {
  return `
    <div id="answer-${answer.id}">
      ${answer.body}
      <p class="actions">
        <a href="/answers/${answer.id}" data-remote="true">Show</a>
      </p>
      <p>Comments</p>
      <div class="comments"></div>
    </div>
  `
}
