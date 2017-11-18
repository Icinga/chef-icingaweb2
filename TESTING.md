# Testing
## Prerequisites
We recommend to install [ChefDK] to your development environment.
It provides all tools used in the process of testig this cookbook.

Before starting, make sure you have installed all dependencies:

```shell
git clone https://github.com/Icinga/chef-icingaweb2.git icingaweb2
cd icingaweb2
```

## Integration
### Requirements
* [Vagrant]
* [VirtualBox]
* [Docker]

### Run Tests
To run all test suits on all platforms:
```shell
kitchen test
```

Instead of running all integration tests, you can specify each suite and platform to create the instances.
All steps can be run separately.
```
kitchen verify chef13package-amazon
kitchen destroy chef13package-amazon
```

List existing instances
```shell
kitchen list
```

## Spec
Unit tests are implemented in [ChefSpec]/[RSpec]:
```shell
/opt/chefdk/bin/chef exec rake spec
```

## Foodcritic
Linting is done with [Foodcritic]:
```shell
/opt/chefdk/bin/chef exec rake foodcritic
```

## Rubocop
Ruby code is analyzed with [Rubocop]:
```shell
/opt/chefdk/bin/chef exec rake rubocop
```

[ChefDK]: https://downloads.chef.io/chef-dk/
[Vagrant]: https://www.vagrantup.com/
[Virtualbox]: https://www.virtualbox.org/
[ChefSpec]: https://docs.chef.io/chefspec.html
[RSpec]: http://rspec.info/
[Foodcritic]: http://www.foodcritic.io/
[Rubocop]: https://github.com/bbatsov/rubocop
[Docker]: https://www.docker.com/
