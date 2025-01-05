import { Controller } from "@hotwired/stimulus";
import { codeToHtml } from 'https://esm.sh/shiki@1.26.1'

// Connects to data-controller="markdown--code"
export default class extends Controller {
  static values = {
    language: String,
    code: String
  }

  async connect() {
    const html = await codeToHtml(this.codeValue, {
      lang: this.languageValue,
      theme: 'vitesse-dark'
    });

    this.element.innerHTML = html;
  }
}
