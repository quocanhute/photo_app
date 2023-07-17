import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  static targets = ["photoContent", "albumContent"]
  connect() {
    this.albumContentTarget.style.display = "none";
  }
  buttonPhoto(){
    this.photoContentTarget.style.display = 'block';  // Show the photo content
    this.albumContentTarget.style.display = 'none';
  }

  buttonAlbum(){
    this.photoContentTarget.style.display = 'none';  // Show the photo content
    this.albumContentTarget.style.display = 'block';
  }
}
