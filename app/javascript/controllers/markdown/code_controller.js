import { Controller } from "@hotwired/stimulus";
import { codeToHtml } from 'https://esm.sh/shiki@1.26.1'

// Connects to data-controller="markdown--code"
export default class extends Controller {
  static values = {
    language: String
  }

  async connect() {
    const element = this.element;
    const code = element.innerHTML;

    const html = await codeToHtml(code, {
      lang: this.languageValue,
      theme: 'vitesse-dark'
    });

    element.innerHTML = html;
  }
}
