# Package

The appserver.io distribution package building, testing and release helper library

# Issues
In order to bundle our efforts we would like to collect all issues regarding this package in [the main project repository's issue tracker](https://github.com/appserver-io/appserver/issues).
Please reference the originating repository as the first element of the issue title e.g.:
`[appserver-io/<ORIGINATING_REPO>] A issue I am having`

# Usage
This package provides a [vagrant](https://www.vagrantup.com/) wrapper around common packaging and test targets we use to build OS specific packages.

Being a wrapper which should also be usage "un-wrapped" this package offers different [ant](http://ant.apache.org/) targets following a certain syntax:

| Prefix     | Implication                                                                                                   |
| -----------| --------------------------------------------------------------------------------------------------------------|
| `local-`   | Any ant call prefixed with `local-`, e.g. `local-build`, will be locally executed without the use of vagrant. |
| `vagrant-` | The `vagrant-` prefix will trigger the remote execution within a vagrant box which is considered currently running in a specific `tmp` directory.
    Internally uses the `local-` prefix to make the actual call within the box. |
| none       | The ant call will be executed in a new vagrant box which will get started first, the call will be remotely made within the box and the box will be destroyed after the call returned.
    Internally uses the `vagrant-` prefix to make the remote call.   |

Targets which can be used together with the mentioned prefixes are:

| Target      | Description                                                                                                            |
| ------------| -----------------------------------------------------------------------------------------------------------------------|
| `build`     | Builds the package using the `package` library. Mostly triggers the `local-build` target which gets overriden locally. |
| `run-tests` | Will trigger test execution for recently built packages. Has several variations which only trigger certain parts of the tests. E.g. `run-integration-tests` |