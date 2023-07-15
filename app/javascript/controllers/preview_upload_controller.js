import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-upload"

// export default class extends Controller {
//   static targets = ["input", "previewContainer"];
//   files = [];
//
//   connect() {
//     this.previewImages();
//
//     // Sự kiện "change" chỉ được gắn vào input khi không có sự kiện "change" đã được gắn trước đó
//     if (!this.inputTarget.onchange) {
//       this.inputTarget.addEventListener("change", this.previewImages.bind(this));
//     }
//   }
//
//   previewImages() {
//     const newFiles = Array.from(this.inputTarget.files);
//
//     // Thêm các tệp mới vào danh sách files
//     this.files.push(...newFiles);
//     const files = Array.from(this.inputTarget.files);
//     this.previewContainerTarget.innerHTML = "";
//
//     files.forEach((file) => {
//       const reader = new FileReader();
//
//       reader.onload = (event) => {
//         const imageUrl = event.target.result;
//         const imgTag = document.createElement("img");
//         imgTag.src = imageUrl;
//
//         const deleteButton = document.createElement("button");
//         deleteButton.innerText = "Delete";
//         deleteButton.addEventListener("click", () => {
//           this.deletePreviewImage(imgTag);
//           this.updateFileField();
//         });
//
//         const imageContainer = document.createElement("div");
//         imageContainer.appendChild(imgTag);
//         imageContainer.appendChild(deleteButton);
//
//         this.previewContainerTarget.appendChild(imageContainer);
//       };
//
//       reader.readAsDataURL(file);
//     });
//   }
//
//   deletePreviewImage(imageElement) {
//     imageElement.parentNode.remove();
//
//     // Xóa hình ảnh khỏi danh sách files
//     const index = this.files.indexOf(imageElement.src);
//     if (index !== -1) {
//       this.files.splice(index, 1);
//     }
//   }
//
//   updateFileField() {
//     const previewImages = Array.from(this.previewContainerTarget.querySelectorAll("img"));
//     const fileField = document.getElementById("album_images");
//     const files = previewImages.map((img) => {
//       return this.dataURLtoFile(img.src, "image.jpg");
//     });
//
//     const fileList = new DataTransfer();
//     files.forEach((file) => {
//       fileList.items.add(file);
//     });
//
//     fileField.files = fileList.files;
//   }
//
//   dataURLtoFile(dataURL, filename) {
//     const arr = dataURL.split(",");
//     const mime = arr[0].match(/:(.*?);/)[1];
//     const bstr = atob(arr[1]);
//     let n = bstr.length;
//     const u8arr = new Uint8Array(n);
//
//     while (n--) {
//       u8arr[n] = bstr.charCodeAt(n);
//     }
//
//     return new File([u8arr], filename, { type: mime });
//   }
// }




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