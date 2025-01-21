import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="components--copy-to-clipboard"
export default class extends Controller {
  static values = {
    value: String
  }

  copy() {
    navigator.clipboard.writeText(this.valueValue)
      .then(() => {
        // success
      })
      .catch((error) => {
        // fail
      });
  }
}
