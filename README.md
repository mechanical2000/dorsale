[![Build Status](https://semaphoreci.com/api/v1/agilidee/dorsale/branches/master/badge.svg)](https://semaphoreci.com/agilidee/dorsale)
[![Maintainability](https://api.codeclimate.com/v1/badges/c3b2143566f714fcb104/maintainability)](https://codeclimate.com/github/agilidee/dorsale/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c3b2143566f714fcb104/test_coverage)](https://codeclimate.com/github/agilidee/dorsale/test_coverage)

# Dorsale

This project uses the GNU AGPLv3 license.


## Trying the dummy app:

```
cd spec/dummy
rails server
go to http://localhost:3000/
```

## Requirements
Hosting application shall define a global current_user method providing the current logged user.

Returned user shall implement followings methods:
tasks: returns all taks visible by the user
colleagues(context): return all people affected in the provided context
