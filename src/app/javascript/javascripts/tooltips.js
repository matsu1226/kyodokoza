export default() => {
  // let exampleEl = document.getElementById('tooltip_elm')
  // let tooltip = new bootstrap.Tooltip(exampleEl, options)
  $(function () {
    $('[data-bs-toggle="tooltip"]').tooltip()
  })
}
