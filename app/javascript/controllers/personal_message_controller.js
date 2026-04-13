import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, placeholder: String }

  focus() {
    if (this.element.textContent.trim() === this.placeholderValue) {
      this.element.textContent = ""
    }
  }

  keydown(event) {
    if (event.key === "Enter") { event.preventDefault(); this.element.blur() }
    if (event.key === "Escape") { this._cancel() }
    if (this.element.textContent.length >= 129 && event.key.length === 1) {
      event.preventDefault()
    }
  }

  save() {
    const value = this.element.textContent.trim()
    const original = this.element.dataset.original

    if (value === original) {
      if (!value) this.element.textContent = this.placeholderValue
      return
    }

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]")?.content
      },
      body: JSON.stringify({ user: { personal_message: value } })
    }).then(r => {
      if (r.ok) {
        this.element.dataset.original = value
        this.element.dataset.saved = "true"
        if (!value) this.element.textContent = this.placeholderValue
      } else {
        this._cancel()
      }
    })
  }

  _cancel() {
    const original = this.element.dataset.original
    this.element.textContent = original || this.placeholderValue
  }
}
