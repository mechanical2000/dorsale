# Changelog

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
