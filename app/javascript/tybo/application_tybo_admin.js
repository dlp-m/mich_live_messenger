import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

import Attachments from "tybo/controllers/attachments_controller"
import Dropdown from "tybo/controllers/dropdown_controller"
import Flash from "tybo/controllers/flash_controller"
import SearchForm from "tybo/controllers/search_form_controller"
import TsSearch from "tybo/controllers/ts/search_controller"
import TsSelect from "tybo/controllers/ts/select_controller"
import Sidebar from "tybo/controllers/sidebar_controller"

const application = Application.start()

application.register("tybo--attachments", Attachments)
application.register("tybo--dropdown", Dropdown)
application.register("tybo--flash", Flash)
application.register("tybo--search-form", SearchForm)
application.register("tybo--ts--search", TsSearch)
application.register("tybo--ts--select", TsSelect)
application.register("tybo--sidebar", Sidebar)
