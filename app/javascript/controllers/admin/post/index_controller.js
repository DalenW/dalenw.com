import { Controller } from "@hotwired/stimulus";
import { createGrid, ClientSideRowModelModule, CsvExportModule } from 'ag-grid-community';
import { themeQuartz } from 'ag-grid-community';


// Connects to data-controller="admin--post--index"
export default class extends Controller {
  static values = {
    posts: Array
  }

  connect() {
    this.initializeGrid()
  }

  initializeGrid() {
    // to use myTheme in an application, pass it to the theme grid option
    const myTheme = themeQuartz
      .withParams({
        backgroundColor: "#1f2836",
        browserColorScheme: "dark",
        chromeBackgroundColor: {
          ref: "foregroundColor",
          mix: 0.07,
          onto: "backgroundColor"
        },
        foregroundColor: "#FFF",
        headerFontSize: 14
      });

    const columnDefs = [
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

      { field: 'status', sortable: true, filter: true },
      {
        headerName: '',
        field: 'id',
        cellRenderer: params => {
          return `<a class="btn btn-primary btn-sm" href="/admin/post/${params.value}">
            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-right"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l14 0" /><path d="M13 18l6 -6" /><path d="M13 6l6 6" /></svg>
          </a>`
        }
      }
    ]



    const gridOptions = {
      theme: myTheme,
      columnDefs: columnDefs,
      rowData: this.postsValue,
      defaultColDef: {
        flex: 1,
        minWidth: 100,
        resizable: true
      },
      domLayout: 'autoHeight'
    }

    new createGrid(this.element, gridOptions, {
      modules: [ClientSideRowModelModule, CsvExportModule]
    })
  }
}