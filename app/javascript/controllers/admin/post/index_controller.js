import {AgGridController} from "controllers/ag_grid_controller";

export default class extends AgGridController {
  columnDefs() {
    return [
      { field: 'id', sortable: true, filter: 'agNumberColumnFilter' },
      { field: 'title', sortable: true, filter: true },
      { field: 'description', sortable: true, filter: true },
      {
        field: 'created_at',
        sortable: true,
        filter: true,
        cellRenderer: params => {
          return `<span data-controller="format--date">${params.value}</span>`
        }
      },
      {
        field: 'published_at',
        sortable: true,
        filter: true,
        cellRenderer: params => {
          return `<span data-controller="format--date">${params.value}</span>`
        }
      },
      {
        field: 'status',
        sortable: true,
        filter: 'agNumberColumnFilter'
      },

      {
        headerName: '',
        field: 'id',
        cellRenderer: params => {
          return `<a class="btn btn-primary btn-sm" href="/admin/post/${params.value}">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-right"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M13 18l6 -6" /><path d="M13 6l6 6" /></svg>
          </a>`
        }
      }
    ];
  }
}