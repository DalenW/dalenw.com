import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="components--copy-to-clipboard"
export default class extends Controller {
  static values = {
    value: String
  }

  connect() {
    // console.log(this.valueValue);
  }

  copy() {
    navigator.clipboard.writeText(this.valueValue)
      .then(() => {
        // success
        // console.log("copied");
      })
      .catch((error) => {
        // fail
        console.log("copy component error", error);
      });
  }
}
