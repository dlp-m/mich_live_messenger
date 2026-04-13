import { Controller } from "@hotwired/stimulus"

const STATUS_COLORS = { available: "#22aa22", away: "#ddaa22", busy: "#cc4444" }
const AVATAR_GRADIENTS = {
  available: "linear-gradient(to bottom right,#b0e050,#66cc22,#3a9010)",
  away:      "linear-gradient(to bottom right,#f0c040,#ddaa22,#aa7700)",
  busy:      "linear-gradient(to bottom right,#f07070,#cc4444,#aa1010)"
}

export default class extends Controller {
  static targets = ["menu", "dot", "label", "avatarFrame"]
  static values = { url: String, field: String }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  select(event) {
    const status = event.currentTarget.dataset.status
    if (!status) return

    if (this.hasDotTarget) this.dotTarget.style.backgroundColor = STATUS_COLORS[status]
    if (this.hasLabelTarget) this.labelTarget.textContent = event.currentTarget.dataset.label
    if (this.hasAvatarFrameTarget) this.avatarFrameTarget.style.background = AVATAR_GRADIENTS[status]

    if (this.hasFieldValue) {
      const field = document.getElementById(this.fieldValue)
      if (field) field.value = status
    }

    if (this.hasUrlValue) {
      fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name=csrf-token]")?.content
        },
        body: JSON.stringify({ user: { status } })
      })
    }

    this.menuTarget.classList.add("hidden")
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  connect() {
    this._closeHandler = this.close.bind(this)
    document.addEventListener("click", this._closeHandler)
  }

  disconnect() {
    document.removeEventListener("click", this._closeHandler)
  }
}
