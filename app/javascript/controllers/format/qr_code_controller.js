import { Controller } from "@hotwired/stimulus";
import QRious from "qrious";

// Connects to data-controller="format--qr-code"
export default class extends Controller {
  static values = {
    url: String,
  }

  connect() {
    const element = this.element;
    const url = this.urlValue;

    // const parentElement = element.parentElement;

    // element.width = parentElement.clientWidth;
    // element.height = parentElement.clientHeight;

    // size is the width of element
    let size = element.offsetWidth;

    let qr = new QRious({
      element: element,
      value: url,
      size: size,
      level: 'Q', //https://blog.qrstuff.com/2011/12/14/qr-code-error-correction
      foreground: '#000000'
    });

    this.qr = qr;
    // console.log(qr);

    /*

    attempted to resize the qr code automatically, no luck. I'll just leave it as is.


    // setup a resize listener for parentElement
    window.addEventListener('resize', () => {
      console.log('resize');
      // console.log(parentElement.clientWidth);
      // console.log(parentElement.clientHeight);

      size = element.offsetWidth;
      qr.size = size;
      qr.update();
    });
    */
  }
}
