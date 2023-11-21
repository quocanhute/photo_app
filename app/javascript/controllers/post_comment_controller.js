import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-comment"
export default class extends Controller {
  connect() {
  }

  clickReplyButton(event) {
    let element = event.target.closest('.comment-form-display')
    if (!element) return;
    event.preventDefault();
    element.nextElementSibling.classList.remove('d-none')
  }

  clickCancel(event) {
    if (!event.target.matches('.cancel')) return;
    event.preventDefault()
    let element = event.target.closest('.comment-form')
    element.classList.add('d-none')
  }
}
