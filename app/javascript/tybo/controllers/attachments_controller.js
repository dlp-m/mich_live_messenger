import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static values = { url: String, method: String, attachmentId: Number }

  async toggle(event) {
    event.preventDefault()

    const request = new FetchRequest(this.methodValue, this.urlValue, { responseKind: "turbo-stream", body: { attachment_id: this.attachmentIdValue } })
    await request.perform()
  }
}
