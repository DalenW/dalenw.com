import { Controller } from "@hotwired/stimulus";
import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";

// Connects to data-controller="markdown--content"
// base js for a markdown content view
export default class extends Controller {
  connect() {
    mermaid.initialize(
      {
        startOnLoad: false,
        securityLevel: 'loose'
      }
    );

    mermaid.run();
  }
}
