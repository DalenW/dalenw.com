import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="blog--gallery-image"
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
