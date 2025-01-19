import { Controller } from "@hotwired/stimulus";
import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
// import katex from "https://cdn.jsdelivr.net/npm/katex@0.16.19/dist/katex.mjs";
import renderMathInElement from "https://cdn.jsdelivr.net/npm/katex@0.16.19/dist/contrib/auto-render.mjs";

// Connects to data-controller="markdown--content"
// base js for a markdown content view
export default class extends Controller {
  connect() {
    mermaid.initialize(
      {
        startOnLoad: false,
        securityLevel: 'loose',
        theme: 'dark'
      }
    );
    mermaid.run();

    // https://katex.org/docs/autorender#api
    renderMathInElement(this.element, {
      delimiters: [
        {left: "$$", right: "$$", display: true},
        {left: "$", right: "$", display: true},
        {left: "\\(", right: "\\)", display: false},
        {left: "\\begin{equation}", right: "\\end{equation}", display: true},
        {left: "\\begin{align}", right: "\\end{align}", display: true},
        {left: "\\begin{alignat}", right: "\\end{alignat}", display: true},
        {left: "\\begin{gather}", right: "\\end{gather}", display: true},
        {left: "\\begin{CD}", right: "\\end{CD}", display: true},
        {left: "\\[", right: "\\]", display: true}
      ]
    });
  }
}
