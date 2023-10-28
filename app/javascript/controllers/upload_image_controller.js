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
      const reader = new FileReader();

      reader.onload = (e) => {
        this.avatarTarget.src = e.target.result;
      };

      reader.readAsDataURL(file);
      toastr.success('Image was uploaded successfully!', 'SUCCESS')
    }
    catch (err){
      toastr.error(err.message, 'ERROR')
    }

  }
}
