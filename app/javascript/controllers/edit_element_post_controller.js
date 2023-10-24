import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-element-post"
export default class extends Controller {
  connect() {
  }
  static targets = []

  clickParagraphContent(event) {
    let element = event.target.closest('.paragraph-content')
    if (!element) return;

    element.classList.add('d-none')
    element.nextElementSibling.classList.remove('d-none')
  }

  clickCancel(event) {
    if (!event.target.matches('.cancel')) return;
    event.preventDefault()
    let element = event.target.closest('.paragraph-form')
    element.classList.add('d-none')
    element.previousElementSibling.classList.remove('d-none')
  }

}
