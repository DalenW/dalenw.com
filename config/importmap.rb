# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
pin "trix", preload: false
pin "@rails/actiontext", to: "actiontext.esm.js", preload: false

pin_all_from "app/javascript", preload: false
pin "ag-grid-community" # @33.1.1
pin "qrious" # @4.0.2
