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
    // console.log(checkbox.value);
    if (!checkbox.checked) {
      this.products.push(checkbox.value);

    }else {
      const index = this.products.indexOf(checkbox.value);
      this.products.splice(index, 1)
    }
    console.log(this.products)
  }
}
