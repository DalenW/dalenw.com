import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="components--expand-image"
export default class extends Controller {
  connect() {
    const parent = this.element;

    const img = parent.querySelector("img");

    console.log(parent);

    const expandButtonHtml = `
      <div class="absolute top-0 left-0 w-full h-full flex justify-center align-middle hover:bg-base-200 hover:opacity-50 opacity-0">
        <a class="w-full h-full" data-action="components--expand-image#expand">
          <div class="w-full h-full m-auto flex justify-center items-center align-middle">
            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrows-maximize"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M16 4l4 0l0 4" /><path d="M14 10l6 -6" /><path d="M8 20l-4 0l0 -4" /><path d="M4 20l6 -6" /><path d="M16 20l4 0l0 -4" /><path d="M14 14l6 6" /><path d="M8 4l-4 0l0 4" /><path d="M4 4l6 6" /></svg>  
          </div>
        </a>
      </div>
    `;

    const expandButtonElement = document.createRange().createContextualFragment(expandButtonHtml);

    parent.appendChild(expandButtonElement);
  }

  expand() {
    console.log("expand");
  }
}
