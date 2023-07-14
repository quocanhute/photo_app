import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-upload"
export default class extends Controller {
  static targets = [ "input", "preview" ]

  connect() {
  }
  exist_data = [];
  test() {
    const files = this.inputTarget.files

    if (files && files.length > 0) {
      Array.from(files).forEach(file => {
        const reader = new FileReader()

        reader.onload = (event) => {
          const image = document.createElement('img')
          image.src = event.target.result
          this.previewTarget.appendChild(image)
        }

        reader.readAsDataURL(file)
      })
    }
  }
}