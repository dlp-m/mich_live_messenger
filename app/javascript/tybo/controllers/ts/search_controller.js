import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'
import TomSelect from "tom-select"

export default class extends Controller {
  static values = { url: String }

  connect() {
    new TomSelect(this.element, {
      plugins: ['clear_button'],
      valueField: 'value',
      load: (q, callback) => this.search(q, callback)
    })
  }

  async search(q, callback) {
    const response = await get(this.urlValue, {
      query: { q: q },
      responseKind: 'json'
    })

    if (response.ok) {
      const list = await response.json
      callback(list)
    } else {
      callback()
    }
  }
}
