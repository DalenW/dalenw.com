import { Controller } from "@hotwired/stimulus";
import Stackedit from "stackedit-js";

// Connects to data-controller="components--form--stackedit"
export default class extends Controller {
  static targets = [
    "textarea",
    "stackeditContainer"
  ];
  connect() {
    this.stackedit = new Stackedit();

    const that = this;

    this.textareaTarget.addEventListener("click", () => {
      that.open();
    });

    // Listen to StackEdit events and apply the changes to the textarea.
    this.stackedit.on('fileChange', (file) => {
      this.textareaTarget.value = file.content.text;
    });

    this.open();
  }

  open() {
    // Open the iframe
    this.stackedit.openFile({
      name: 'Post', // with an optional filename
      content: {
        text: this.textareaTarget.value // and the Markdown content.
      }
    }, this.stackeditContainerTarget);
  }
}
