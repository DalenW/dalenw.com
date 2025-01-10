import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="admin--post--edit"
export default class extends Controller {
  static targets = [
    "fileUpload"
  ]
  connect() {
    const form = this.element;
    const fileUpload = this.fileUploadTarget;

    fileUpload.addEventListener("change", () => {
      console.log("fileUpload change", fileUpload);
      form.requestSubmit();
    });


  }
}
