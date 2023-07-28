<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/quocanhute/photo_app">
    https://github.com/quocanhute/photo_app
  </a>

<h3 align="center">PhotoBook</h3>

  <p align="center">
    Ứng dụng chia sẻ ảnh và allbum trực tiếp
    <br />
    <br />
    <a href="https://photoapp-mj7g.onrender.com">View Demo click me!!</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://photoapp-mj7g.onrender.com/)




### Built With

* [![Rails][RoR.rb]][ror-url]
* [![Ruby][Ruby.rb]][ruby-url]
* [![Bootstrap][Bootstrap.com]][Bootstrap-url]
* [![JQuery][JQuery.com]][JQuery-url]

<hr/>



<!-- GETTING STARTED -->
## Các phần mềm yêu cầu

1. Ruby version 3.0.0
2. Rails version >= 7.0.0
3. Database PostgreSQL

### Tiến hành cài đặt


1. Clone project từ link github 
  ```sh
  git clone https://github.com/quocanhute/photo_app
  ```
2. Thay tên file .env.example thành .env và config các key có ở trong file
```
CLOUDINARY_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=

MAILER_DOMAIN=
MAILER_USER_NAME=
MAILER_PASSWORD=
MAILER_HOST=
  ```

3. Tạo database cho từng môi trường chạy 
  ```sh
  bin/rails db:create 
  ```
4. Chạy migrate để tạo bảng 
  ```sh
  bin/rails db:migrate
  ```
  
5. Chạy seed để tạo dữ liệu
  ```sh
  bin/rails db:seed 
  ```
  
6. Run server 
  ```sh
  bin/rails server  
  ```

<hr/>

<!-- USAGE EXAMPLES -->
## Sử dụng 

Nếu là khách thì sẽ có các page sau để sử dụng

1. Màn hình chính
   [![Product Name Screen Shot][product-screenshot]](https://photoapp-mj7g.onrender.com/)
2. Màn hình xem các photo được chia sẻ công khai
   ![Product Name Screen Shot][view_all_photo_guest]
3. Màn hình xem các album được chia sẻ công khai
   ![Product Name Screen Shot][view_all_album_guest]
4. Màn hình xem các thông tin người dùng
   ![Product Name Screen Shot][view_detail_user]


Và các chức năng để sử dụng

1. Đăng nhập
![Email Confirm][login-page]

2. Đăng ký
![Email Confirm][sign-up-page]

Sau khi đã chạy ``` bin/rails db:seed``` ta sẽ có 2 loại tài khoản dành cho 2 roles khác nhau đó là
1. Admin
```angular2html
TK: admin@admin.com
MK: 123456
```
2. User 
```angular2html
TK: user@user.com
MK: 123456
```
Vì ứng dụng có sử dụng mailer để gửi mails xác thực tài khoản nên khi đăng nhập
chúng ta cần vào thư mục mail mình đã config để tìm đường link xác thực.

Ex:

![Email Confirm][email-confirm]




Sau khi đăng nhập thành công 
1. Role User
![Email Confirm][user_homepage]
2. Role Admin
![Email Confirm][admin_homepage]

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

See the [open issues](https://github.com/github_username/repo_name/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email@email_client.com

Project Link: [https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo_name.svg?style=for-the-badge
[contributors-url]: https://github.com/github_username/repo_name/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo_name.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo_name/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo_name.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo_name/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo_name.svg?style=for-the-badge
[issues-url]: https://github.com/github_username/repo_name/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo_name.svg?style=for-the-badge
[license-url]: https://github.com/github_username/repo_name/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: git-image/homepage.png
[email-confirm]: git-image/email-confirm.png
[login-page]: git-image/login-page.png
[sign-up-page]: git-image/sign-up.png
[view_all_photo_guest]: git-image/view_all_photo_guest.png
[view_all_album_guest]: git-image/view_all_album_guest.png
[view_detail_user]: git-image/view_profile.png
[admin_homepage]: git-image/admin_homepage.png
[user_homepage]: git-image/user_homepage.png

[RoR.rb]: https://img.shields.io/badge/RoR-C3A660?style=for-the-badge&logo=ruby&logoColor=D45839
[RoR-url]: https://rubyonrails.org/
[Ruby.rb]: https://img.shields.io/badge/Ruby-C3A660?style=for-the-badge&logo=ruby&logoColor=D45839
[Ruby-url]: https://www.ruby-lang.org/en/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 