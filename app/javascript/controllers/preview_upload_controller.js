import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-upload"
export default class extends Controller {
  static targets = ["input", "previewContainer"]
  files = []

  connect() {
    this.updatePreview()
  }

  updatePreview() {
    const newFiles = Array.from(this.inputTarget.files)

    newFiles.forEach(file => {
      const reader = new FileReader()

      reader.onload = (event) => {
        const imageUrl = event.target.result
        const img = document.createElement("img")
        img.src = imageUrl

        const deleteButton = document.createElement("button")
        deleteButton.innerText = "Delete"
        deleteButton.addEventListener("click", () => {
          this.removeImage(img, file)
        })

        const imageContainer = document.createElement("div")
        imageContainer.appendChild(img)
        imageContainer.appendChild(deleteButton)

        this.previewContainerTarget.appendChild(imageContainer)
      }

      reader.readAsDataURL(file)
    })

    this.files = this.files.concat(newFiles)
    this.updateInputValue()
  }

  removeImage(img, file) {
    const imageContainer = img.parentNode
    imageContainer.parentNode.removeChild(imageContainer)

    this.files = this.files.filter(f => f !== file)
    this.updateInputValue()
  }

  updateInputValue() {
    const input = this.inputTarget
    input.value = ""

    const dataTransfer = new DataTransfer()
    this.files.forEach(file => {
      dataTransfer.items.add(file)
    })

    input.files = dataTransfer.files
  }
}