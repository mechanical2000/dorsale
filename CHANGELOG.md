# Changelog

## Next version

# 3.19.1
- Expenses : add colors to list

# 3.19.0
- Change expenses state machine
- Change expenses list view

# 3.18.0
- Change uploaders `extension_whitelist` to `extension_allowlist`
- Rails 6.1 compatibility

## 3.17.0
- Refactor CV models using stores
- Fix redirect after task comment create
- Add missing unique indexes on invoices and quotations

## 3.16.0
- Allow to reorder BM lines (require Sorting.js + reimport migrations)
- Remove unused url.js

## 3.15.0
- Fix Ruby 2.7 warnings
- Faker 2

## 3.14.11
- Fix BM missing PDFs

## 3.14.10
- Change BillingMachine PDF filenames
- Fix CustomerVault layout

## 3.14.9
- Create corporation from individual form
- Quotations: add draft state
- Fix carrierwave white lists

## 3.14.8
- Rails 6

## 3.14.7
- Freeze ttfunk to <1.6 to fix PDF errors

## 3.14.6
- Small changes on BM policy check

## 3.14.5
- Restore test files in gemspec

## 3.14.4
- Expenses : add PDF export

## 3.14.3
- BillingMachine minor fixes

## 3.14.2
- Fix CustomerVault factories

## 3.14.1
- "Task snoozed" comment improvements

## 3.14.0
- Add `Dorsale::BillingMachine.vat_round_by_line` option
- Revert default `vat_round_by_line` value introduced in 3.10.0 (it's now false again)

## 3.13.0
- Rails 5.2 compatible

## 3.12.0
- Change attachment observers

## 3.11.0
- Various updates
- Remove bh gem dependency

## 3.10.3
- Fix BillinMachine JS error

## 3.10.2
- Update Ruby and Gems

## 3.10.1
- Email fixes and improvements

## 3.10.0
- Billing Machine : fix amounts round
- Billing Machine : change ::DEFAULT_VAT_RATE to ::default_vat_rate
- Billing Machine : refactor/improve JS

## 3.9.8
- Tasks : add increment progress buttons
- Tasks : small improvements

## 3.9.7
- Attachments : refactor + sorting

## 3.9.6
- Tasks : add :on_warning_or_alert scope/filter
- Tasks : fix redirect after create comment

## 3.9.5
- Fix BillingMachine preview JS

## 3.9.4
- BillingMachine : add invoice/quotation preview
- BillingMachine : add quotation email + refactor email service
- Various small fixes

## 3.9.3
- BillingMachine : Fix payment status filter

## 3.9.2
- CustomerVault : Add secondary emails + uniqueness validation

## 3.9.1
- Add tags to tasks

## 3.9.0
- Remove BM id cards
- Syntax improvements and refactors

## 3.8.1
- Change CV contact type default value

## 3.8.0
- Move CV comments to events
- Add CV event contact type
- Various fixes

## 3.7.8
- Person build address improvement

## 3.7.7
- Change redirect after create task comment

## 3.7.6
- Add table names on SQL queries

## 3.7.5
- Task improvements

## 3.7.4
- Change nilify_blanks config
- CustomerVault Events : persist text
- CustomerVault : delete event when deleting comment
- Comments : fix double comments JS
- CustomerVault : do not validate events author
- CustomerVault : move PeopleController#activity to EventsController#index
- CustomerVault : add events filters

## 3.7.3
- Fix copy action

## 3.7.2
- Add sorting for task comments
- Add copy for tasks
- Add comment when reporting

## 3.7.1
- Add activity type and origin filters for people
- Add activity type and origin in people export

## 3.7.0
- Remove some useless "polymorphic" belongs_to
- Add `comment?` action to task policy
- CustomerVault : origins and activity types

## 3.6.1
- CSS fix

## 3.6.0
- Task term and reminder improvements
- Add CustomerVault events

## 3.5.2
- Comments improvements
- Add infos to people context

## 3.5.1
- Add title and date to comments
- Truncate comments
- CustomerVault : individual belongs to corporation
- CustomerVault : add/remove fields

## 3.5.0
- Move helpers/i18n/... to agilibox gem
  - rename `dorsale_button` helper to `bs_button`
  - rename `dorsale_time_periods_for_select` helper to `agilibox_time_periods_for_select`

## 3.4.0
- Delete Flyboy folders
- Add `link_to_object` helper
- Change/fix expense states (new -> draft, submited -> submitted)
- Persist invoice/quotation PDFs after save
- Add concerns to ApplicationRecord and stop pollute ActiveRecord::Base
- Replace abandoned gem handles_sortable_columns

## 3.3.0
- Add download of all invoices in pdf
- Rename `render_dorsale_index` to `render_dorsale_page`
- Replace `render_contextual` by `render_dorsale_page`
- Change some view/partial names
- Fix js reset button
- Print CSS add flash

## 3.2.0
- Add print CSS
- UUID friendly
- Add missing indexes
- Add `:default` option to `info` helper
- Refactor
- Add nilify_blanks gem
- Add invoices chart
- CustomerVault improvements + add invoices tab
- Comments improvements
- Remove tasks PDF and CSV export (XLSX still present)
- Convert CSV exports to XLSX
- XLSX Serializer improvements

## 3.1.7
- Filters changes : get/set are now private
- Add Bullet gem
- Add ApplicationRecord

## 3.1.6
- Migrate tests to PhantomJS 2
- Add more time period filters
- Fix avatar concern error

## 3.1.5
- Move filters to app/filters
- Tags refactor
- Rename `person_tags` helper to `tags`

## 3.1.4
- Add attachment types

## 3.1.3
- Fix delete people

## 3.1.2
- Fix gemspec test files

## 3.1.1
- Minor fixes

## 3.1.0
- Migrate from CanCan to Pundit
- ExpenseGun improvements
  - UX
  - Nested form
  - Copy expense
- Replace Selectize by Select2
- Changes js/css file names :
  - dorsale/dependencies
  - dorsale/common
  - dorsale/engines
- CustomerVault improvements
  - Corporation and Individual merged into STI model
  - Add avatar and other new fields
  - Add Corporations and Individuals lists
- Refactoring
- UX improvements
- Use ajax to CRUD comments
- Fix missing i18n

## 3.0.3
- Refactor controllers
- Refactor back url
- Update config cucumber
- Rename abilities (index => list, show => read)
- Change some redirects after create/update

## 3.0.2
- Add new controllers :
  - Expense Categories
  - Payment Terms
  - Id Cards
- Fix Expenses VAT min amount

## 3.0.1
- Fix ExpenseGun min amounts

## 3.0.0
- Migrate to Rails 5
- Drop Rails 4 support
- Delete 2.8.x versions

## 2.7.3
- Fix Fix ActiveRecordCommaTypeCast to accept NBSP

## 2.7.2
- Small refactor on ExpenseGun

## 2.7.1
- Modals improvements

## 2.7.0
- Add ajax to attachments + progress bar
- Small CSS fixes

## 2.6.8
- Small changes to bootstrap_nav_left.sass

## 2.6.7
- Update Ruby development version to 2.2.5
- Update Rails developement version
- Remove Gemfile.lock from Git
- Add zip-zip gem for compabibility

## 2.6.6
- Fix negative amount on BillingMachine

## 2.6.5
- Add XLSX serializer
- Datepicker : add today button + autoclose

## 2.6.4
- Add datepicker setup after cocoon insert

## 2.6.3
- Add generic filters

## 2.6.2
- Invoices small changes and refactor

## 2.6.1
- Add modals css/js

## 2.6.0
- Add currencies support in BillingMachine (default is ???)

## 2.5.0
- Changes/refactor on invoice/quotation PDFs - it can break extended PDFs

## 2.4.3
- Fix i18n

## 2.4.2
- Minor fix in invoice PDF

## 2.4.1
- ExpenseGun small fixes

## 2.4.0
- Change filters - break compatibility but easy to fix
- Add documents on expenses

## 2.3.5
- Add "In two weeks" on tasks summary
- Add Model::ts to i18n plural model name

## 2.3.4
- Use `polymorphic_path` instead of `url_for`

## 2.3.3
- Helpers small changes

## 2.3.2
- Small changes on users list

## 2.3.1
- Fix path on expense status

## 2.3.0
- Add ExpenseGun

## 2.2.16

- Fix tasks cron

## 2.2.14

- Improve number helpers
- Add Emails for tasks creation

## 2.2.13

- CustomerVault : Fix contact count

## 2.2.12

- CustomerVault : Move create actions to top
- CustomerVault : Remove breadcrumbs
- BillingMachine : Add invoices comments
- BillingMachine : Empty 0 value inputs on focus
- Small fixes

## 2.2.11

- Add avatar support

## 2.2.10

- Fix filters
- Add CustomerVault infos in context
- Move BillingMachine context to top
- Improve `info` helper

## 2.2.9
- Invoices small changes and fixes

## 2.2.8
- Rebuild gem

## 2.2.7
- Send invoices by email
- Add colors to quotations
- Add filter by status to quotations
- Small fixes

## 2.2.6
- Quotation to invoice : edit before save

## 2.2.5
- Fix invoices colors
- Fix invoices totals
- Fix partials names

## 2.2.4
- Attachments : Do not validate presence of sender to allow all attachments without sender to be updated

## 2.2.3
- Add attachments renaming
- Fix invoices errors

## 2.2.2
- Add default value to filters
- Add ability do task comment view

## 2.2.1
- Small fixes on invoices and quotations

## 2.2.0
- Add per line vat rate mode
- Change billing machine column names
- New invoices and quotations views

## 2.1.15

- Hide delete attachment button is not allowed by ability

## 2.1.14

- Add sender to attachments

## 2.1.13

- Add owner to tasks context

## 2.1.12

- Fix comments on destroyed individuals

## 2.1.11

- Add users management
- Change invoices and quotations authorizes

## 2.1.10

- Fix destroy dependencies

## 2.1.9
- Add new template for invoices and quotations

## 2.1.8
- Quotation copy
- Convert quotation to invoice
- Add quotation states
- Add "download" attributes to `download_button` helper

## 2.1.7
- Fix i18n
- Add skype to CustomerVault

## 2.1.6
- Add commercial discount to invoices and quotations

## 2.1.5
- Fix Flyboy error on failing create task

## 2.1.4
- EN i18n fix

## 2.1.3
- Add tasks summary
- Add EN translations

## 2.1.2
- Move People.list to UserScope

## 2.1.1
- Split Flyboy AbilityHelper

## 2.1.0
- Begin migration to UserScope.

## 2.0.2
- Embedded user concept into dorsale: the hosting app now shall provide a current_user with specific methods. Check requirements in README.

## 2.0.1
- Added periods management as decimal separator

## 2.0.0
- Import CustomerVault
- Import BillingMachine
- Import Flyboy
- Create Alexandrie
- More translations
- More helpers and partials
- I18n refactoring
- Filters cookie expiry

## 1.2.6
- Add `engine_polymorphic_path()` helper
- Add number helpers
- Add i18n attributes

## 1.2.5
- Fix JS back_url

## 1.2.4
- JS to add "back_url" to forms

## 1.2.3
- Add helpers : email_link, web_link, tel_link, twitter_link
- Add i18n actions sort and sort_by
- Fix i18n address key

## 1.2.2
- Add bootstrap-datepicker

## 1.2.1
- Ready for ruby 2.2.2
- Pagination style + helper + i18n
- Move filters button in separate helper

## 1.2.0
- Filters
  - Merge instead of replace
  - Import spec
  - Add classes to helper buttons
- I18n
  - Add actions
  - Add attributes
- form_button
  - Add icons
  - Add i18n
- Rewrite context_info helper and add "br" support
- Address
  - Add inverse_of
  - City is now optional
  - Remove controllers and views
- Comments
  - i18n dates
  - Split view

## 1.1.4
- Add filters buttons helper
- Add link_helper
- Add all_helpers
- Add flash partial
- Add common i18n actions, labels, ...

## 1.1.3
- Add button_helper

## 1.1.2
- Fix sprockets/font-awesome error

## 1.1.1
- Fix icon helper (font-awesome icon helper should override bh icon helper)

## 1.1.0
- Import agilidee_commons :
  - Contexts
  - Form helpers
  - simple_form config
  - Text helpers
  - polymorphic_id
- Add small_data (namespaced Dorsale::SmallData)
- Add and require common gem dependencies
- Add commons CSS (tables, forms)

## 1.0.4
- Change redirect after comment

## 1.0.3
- Add Comments

## 1.0.2
- Add Dorsale::Search
