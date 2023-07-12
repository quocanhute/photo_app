// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

// =================================
$(document).ready(function() {
    $('#change-img-field').on('change', function(event) {
        var file = event.target.files[0];
        var reader = new FileReader();
        console.log(file)
        console.log(reader)
        reader.onload = function(e) {
            $('#avatarUser').attr('src', e.target.result);
        };

        reader.readAsDataURL(file);
    });
});
$(document).ready(function() {
    $('#change-img-field-sign').on('change', function(event) {
        var file = event.target.files[0];
        var reader = new FileReader();

        reader.onload = function(e) {
            $('#avatarUserRegister').attr('src', e.target.result);
        };

        reader.readAsDataURL(file);
    });
});

$(document).ready(function() {
    $('#change-photo-field').on('change', function(event) {
        var file = event.target.files[0];
        var reader = new FileReader();

        reader.onload = function(e) {
            $('#imgPhoto').attr('src', e.target.result);
        };

        reader.readAsDataURL(file);
    });
});