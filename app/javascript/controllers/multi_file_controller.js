import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multi-file"
export default class extends Controller {
  connect() {
    console.log("hihi")
  }

  static targets = ['input'];
  products = [];
  toggleValue(event) {
    // const products = [];
    // console.log(input.value)
    const label = event.currentTarget;
    const checkboxId = label.getAttribute('for');
    const checkbox = document.querySelector(`#${checkboxId}`);
    const image = document.getElementById(checkbox.value);
    // console.log(checkbox.value);
    if (!checkbox.checked) {
      this.products.push(checkbox.value);
      image.classList.add("disabled-image");

    }else {
      const index = this.products.indexOf(checkbox.value);
      this.products.splice(index, 1)
      image.classList.remove("disabled-image");
    }
    console.log(this.products)
  }
}
