import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "bg"]

  toggle() {
    this.sidebarTarget.classList.toggle("-translate-x-full")
    this.bgTarget.classList.toggle("opacity-100")
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.bgTarget.classList.remove("opacity-100")
    this.bgTarget.classList.add("opacity-0")
  }
}
