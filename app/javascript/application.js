// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "@popperjs/core"
import "bootstrap"

import "trix"
import "@rails/actiontext"

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