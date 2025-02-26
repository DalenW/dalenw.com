import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="format--date"
export default class extends Controller {
  static values = {
    time: { type: Boolean, default: true },
  }
  connect() {
    const element = this.element;

    // if the element data date calculated is true, then return
    if (element.dataset.dateCalculated === 'true') {
      return;
    }

    const isInput = element.tagName === 'INPUT';

    let value = isInput ? element.value : element.innerHTML;
    value = value.trim();

    if (value === '' || value === null || value === undefined || value === 'null') {
      if (isInput) {
        element.value = 'Null date';
      } else {
        element.innerHTML = `<span class="badge bg-danger bg-glow">Null Date</span>`;
      }
      return;
    }

    const date = this.dateFromString(value);
    let formattedDate = date.toLocaleString();

    if (isNaN(date.getTime())) {
      if (isInput) {
        element.value = 'Not a Date';
      } else {
        element.innerHTML = `<span class="badge bg-danger bg-glow">Not a Date</span>`;
      }
      return;
    }

    if (!this.timeValue) {
      console.log('time');
      // formatted date equals itself but nothing past ', '
      formattedDate = formattedDate.split(', ')[0];
    }

    if (isInput) {
      element.value = formattedDate;
    } else {
      element.innerHTML = formattedDate;
    }

    // add a data attribute called date-calculated to true
    element.setAttribute('data-date-calculated', 'true');
  }

  // from https://stackoverflow.com/a/9413229
  dateFromString(str) {
    const a = str.split(/[^0-9]/).map(s => parseInt(s, 10));
    return new Date(a[0], a[1]-1 || 0, a[2] || 1, a[3] || 0, a[4] || 0, a[5] || 0, a[6] || 0);
  }
}
