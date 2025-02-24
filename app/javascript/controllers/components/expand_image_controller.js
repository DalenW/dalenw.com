import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="components--expand-image"
export default class extends Controller {
  static targets = [
    "modal"
  ]

  connect() {

  }

  expand() {
    this.modalTarget.showModal();
  }
}
