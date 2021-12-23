export default() => {
  document.addEventListener("turbolinks:load",() => {
    jQuery(function ($) {
      $('[data-bs-toggle="tooltip"]')
      .tooltip()
    })
  })
}
