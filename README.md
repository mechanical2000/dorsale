# Dorsale

This project uses the GNU AGPLv3 license.


## Trying the dummy app:

```
cd spec/dummy
rails server
go to http://localhost:3000/
```

## Online demo

https://dorsale-dummy.herokuapp.com

## Requirements
Hosting application shall define a global current_user method providing the current logged user.
Returned user shall implement followings methods:
tasks: returns all taks visible by the user
colleagues(context): return all people affected in the provided context