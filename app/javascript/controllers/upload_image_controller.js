import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload-image"
export default class extends Controller {
  connect() {
  }
  static targets = ['avatar'];

  handleChange(event) {
    const file = event.target.files[0];
    const reader = new FileReader();

    reader.onload = (e) => {
      this.avatarTarget.src = e.target.result;
    };

    reader.readAsDataURL(file);
  }
}
