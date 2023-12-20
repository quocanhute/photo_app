import { Controller } from "@hotwired/stimulus"
// import "toastr"

// Connects to data-controller="upload-image"
export default class extends Controller {
  connect() {
  }
  static targets = ['avatar'];

  handleChange(event) {
    try {
      const file = event.target.files[0];
      if (file) {
        const maxSize = 5 * 1024 * 1024; // 5 MB
        if (file.size > maxSize) {
          toastr.error("File size exceeds the limit of 5MB.", "ERROR");
          event.target.value = ""; // Clear the file input
          return;
        }

        const reader = new FileReader();

        reader.onload = (e) => {
          this.avatarTarget.src = e.target.result;
        };

        reader.readAsDataURL(file);
        toastr.success("Image was uploaded successfully!", "SUCCESS");
      }
    }
    catch (err){
      toastr.error(err.message, 'ERROR')
    }

  }
}
