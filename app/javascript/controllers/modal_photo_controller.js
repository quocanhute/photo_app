import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal-photo"
export default class extends Controller {
  connect() {
    this.showModal();
  }
  showModal() {
    this.element.style.display = "block";
  }
}
