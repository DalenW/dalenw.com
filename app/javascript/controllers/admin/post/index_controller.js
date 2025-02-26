import { Controller } from "@hotwired/stimulus";
import { createGrid, InfiniteRowModelModule, CsvExportModule, TextFilterModule } from 'ag-grid-community';
import { themeQuartz } from 'ag-grid-community';

export default class extends Controller {
  connect() {
    this.initializeGrid()
  }

  initializeGrid() {
    const myTheme = themeQuartz
      .withParams({
        backgroundColor: "#1f2836",
        browserColorScheme: "dark",
        chromeBackgroundColor: {
          ref: "foregroundColor",
          mix: 0.07,
          onto: "backgroundColor"
        },
        foregroundColor: "#ECF9FF",
        headerFontSize: 14
      });

    const columnDefs = [
      { field: 'id', sortable: true, filter: true },
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
        filterParams: {
          values: ['published', 'draft', 'archived'] // adjust based on your status values
        }
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

    const gridOptions = {
      theme: myTheme,
      columnDefs: columnDefs,
      defaultColDef: {
        flex: 1,
        minWidth: 100,
        resizable: true,
        sortable: true,
        filter: true
      },
      domLayout: 'autoHeight',

      // Infinite Row Model settings
      rowModelType: 'infinite',
      cacheBlockSize: 20,
      maxBlocksInCache: 5,
      infiniteInitialRowCount: 1,
      maxConcurrentDatasourceRequests: 2,

      // Datasource for infinite scrolling
      datasource: {
        getRows: (params) => {
          this.gridApi?.showLoadingOverlay();

          const sortModel = params.sortModel;
          const filterModel = params.filterModel;

          fetch('/admin/post.json?' + new URLSearchParams({
            startRow: params.startRow,
            endRow: params.endRow,
            sortModel: JSON.stringify(sortModel),
            filterModel: JSON.stringify(filterModel)
          }))
            .then(response => response.json())
            .then(data => {
              params.successCallback(data.rows, data.lastRow);
              this.gridApi?.hideOverlay();
            })
            .catch(error => {
              console.error('Error fetching data:', error);
              params.failCallback();
              this.gridApi?.hideOverlay();
            });
        }
      }
    };

    new createGrid(this.element, gridOptions, {
      modules: [InfiniteRowModelModule, CsvExportModule, TextFilterModule]
    });
  }
}