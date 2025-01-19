import { Controller } from "@hotwired/stimulus";

// from https://discuss.hotwired.dev/t/how-to-redirect-from-a-form-that-is-inside-a-turbo-frame/4164

// Connects to data-controller="turbo-form-redirect"
export default class extends Controller {
  static values = {
    useTurbo: { type: Boolean, default: true }
  }

  connect() {
    // first clear the event listener
    this.element.removeEventListener("turbo:submit-end", this.next);
    // then add it again
    this.element.addEventListener("turbo:submit-end", this.next);
  }

  next(event) {
    if (event.detail.success) {
      const fetchResponse = event.detail.fetchResponse;
      const url = fetchResponse.response.url;

      if (fetchResponse.response.redirected) {
        window.history.pushState(
          { turbo_frame_history: true },
          '',
          url
        );

        if (this.useTurboValue) {
          window.Turbo.visit(url);
        } else {
          console.log("Not using Turbo");
          window.location.href = url;
        }
      }
    }
  }
}
