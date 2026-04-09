import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  search() {
    const exportBtn = document.getElementById("exportBtn")
    let originalHref = exportBtn.getAttribute("href")
    if (exportBtn) {
      originalHref = originalHref.split('?')[0]

      const params = this.getQueryParams()
      exportBtn.setAttribute("href", `${originalHref}?${params}`)
    }
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }

  getQueryParams() {
    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams(formData).toString()
    return params
  }

  setBooleanField(e) {
    let value = e.target.getAttribute('data-value')
    let targetId = e.target.getAttribute('data-target-id')
    let target = document.getElementById(targetId)
    target.value = value
    this.formTarget.requestSubmit()
  }
}
