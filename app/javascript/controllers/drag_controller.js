import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._initialized = false
  }

  startDrag(event) {
    if (event.button !== 0) return
    event.preventDefault()

    // First drag: convert transform-based centering to explicit top/left
    if (!this._initialized) {
      const rect = this.element.getBoundingClientRect()
      const parentRect = this.element.parentElement.getBoundingClientRect()

      this.element.style.top = (rect.top - parentRect.top) + "px"
      this.element.style.left = (rect.left - parentRect.left) + "px"
      this.element.style.transform = "none"
      this._initialized = true
    }

    this._originX = event.clientX
    this._originY = event.clientY
    this._originLeft = parseFloat(this.element.style.left) || 0
    this._originTop = parseFloat(this.element.style.top) || 0

    this._moveHandler = this._drag.bind(this)
    this._upHandler = this._stopDrag.bind(this)
    document.addEventListener("mousemove", this._moveHandler)
    document.addEventListener("mouseup", this._upHandler)

    this.element.style.cursor = "grabbing"
    this.element.style.userSelect = "none"
  }

  _drag(event) {
    const dx = event.clientX - this._originX
    const dy = event.clientY - this._originY
    const parent = this.element.parentElement

    let newLeft = this._originLeft + dx
    let newTop = this._originTop + dy

    // Constrain inside desktop (exclude taskbar padding-bottom)
    const paddingBottom = parseFloat(getComputedStyle(parent).paddingBottom) || 0
    newLeft = Math.max(0, Math.min(newLeft, parent.offsetWidth - this.element.offsetWidth))
    newTop = Math.max(0, Math.min(newTop, parent.offsetHeight - paddingBottom - this.element.offsetHeight))

    this.element.style.left = newLeft + "px"
    this.element.style.top = newTop + "px"
  }

  _stopDrag() {
    document.removeEventListener("mousemove", this._moveHandler)
    document.removeEventListener("mouseup", this._upHandler)
    this.element.style.cursor = ""
    this.element.style.userSelect = ""
  }
}
