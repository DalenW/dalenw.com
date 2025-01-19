import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="blog--post"
export default class extends Controller {
  static targets = [
    "mobileMenu"
  ]

  connect() {
  }

  showPosts() {

    // this.mobileMenuTarget.classList.remove("hidden");
    this.mobileMenuTarget.classList.remove("-left-full");
    this.mobileMenuTarget.classList.add("left-0");
  }

  hidePosts() {
    this.mobileMenuTarget.classList.remove("left-0");
    this.mobileMenuTarget.classList.add("-left-full");
  }
}
