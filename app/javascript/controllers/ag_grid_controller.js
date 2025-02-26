import {Controller} from "@hotwired/stimulus";
import {
  createGrid,
  CsvExportModule,
  InfiniteRowModelModule,
  NumberFilterModule,
  TextFilterModule,
  themeQuartz
} from 'ag-grid-community';

// Connects to data-controller="ag-grid"
export class AgGridController extends Controller {
  static values = {
    url: String
  }

  connect() {
    this.initializeGrid()
  }

  initializeGrid() {
    new createGrid(this.element, this.gridOptions(), {
      modules: [
        InfiniteRowModelModule,
        CsvExportModule,
        TextFilterModule,
        NumberFilterModule
      ]
    });
  }

  theme() {
    return themeQuartz
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
  }

  columnDefs() {
    return [];
  }

  gridOptions() {
    const url = this.urlValue;
    return {
      theme: this.theme(),
      columnDefs: this.columnDefs(),
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
          this.gridApi?.setGridOption("loading", true);

          const sortModel = params.sortModel;
          const filterModel = params.filterModel;

          fetch(`${url}.json?` + new URLSearchParams({
            startRow: params.startRow,
            endRow: params.endRow,
            sortModel: JSON.stringify(sortModel),
            filterModel: JSON.stringify(filterModel)
          }))
            .then(response => response.json())
            .then(data => {
              params.successCallback(data.rows, data.lastRow);
              this.gridApi?.setGridOption("loading", false);
            })
            .catch(error => {
              console.error('Error fetching data:', error);
              params.failCallback();
              this.gridApi?.setGridOption("loading", false);
            });
        }
      }
    }
  }
}

// Connects to data-controller="ag_grid_controller"
export default class extends AgGridController {
  // having this here prevents errors from being logged (but doesn't cause any issues)
}
