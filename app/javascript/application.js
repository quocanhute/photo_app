// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "@popperjs/core"
import "bootstrap"
import "jquery-ui/widgets/sortable"
import "rails_sortable"
import "toastr"

import "trix"
import "@rails/actiontext"

// $(document).ready(function() {
//   // Your jQuery code goes here
//   $('.toast').toast('show');
// });
// toastr.warning('My name is Inigo Montoya. You killed my father, prepare to die!')
$(function() {
  $('.sortable').railsSortable();
});
// console.log("test something")
// document.addEventListener('turbolinks:load', () => {
//   document.addEventListener('click', () => {
//     console.log("something")
//     let element = event.target.closest('.paragraph-content')
//     if (!element) return;
//
//     element.classList.add('d-none')
//     element.nextElementSibling.classList.remove('d-none')
//   })
//
//   document.addEventListener('click', () => {
//     if (!event.target.matches('.cancel')) return;
//     let element = event.target.closest('.paragraph-form')
//     element.classList.add('d-none')
//     element.previousElementSibling.classList.remove('d-none')
//   })
// })