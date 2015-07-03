# Package

The appserver.io distribution package building, testing and release helper library

# Issues
In order to bundle our efforts we would like to collect all issues regarding this package in [the main project repository's issue tracker](https://github.com/appserver-io/appserver/issues).
Please reference the originating repository as the first element of the issue title e.g.:
`[appserver-io/<ORIGINATING_REPO>] A issue I am having`

# Usage
This package provides a [vagrant](https://www.vagrantup.com/) wrapper around common packaging and test targets we use to build OS specific packages.
It does NOT provide build scripts for different OSs but rather contains common build steps.
For the actual build files have a look at [the distribution packages we offer](https://github.com/appserver-io-dist/).

Being a wrapper which should also be usable "un-wrapped" this package offers different [ANT](http://ant.apache.org/) targets following a certain syntax:

| Prefix     | Implication                                                                                                   |
| -----------| --------------------------------------------------------------------------------------------------------------|
| `local-`   | Any ant call prefixed with `local-`, e.g. `local-build`, will be locally executed without the use of vagrant. |
| `vagrant-` | The `vagrant-` prefix will trigger the remote execution within a vagrant box which is considered currently running in a specific `tmp` directory. Internally uses the `local-` prefix to make the actual call within the box. |
| none       | The ant call will be executed in a new vagrant box which will get started first, the call will be remotely made within the box and the box will be destroyed after the call returned. Internally uses the `vagrant-` prefix to make the remote call.   |

Targets which can be used together with the mentioned prefixes are:

| Target      | Description                                                                                                            |
| ------------| -----------------------------------------------------------------------------------------------------------------------|
| `build`     | Builds the package using the `package` library. Mostly triggers the `local-build` target which gets overriden locally. |
| `run-tests` | Will trigger test execution for recently built packages. Has several variations which only trigger certain parts of the tests. E.g. `run-integration-tests` |

The package is built to work with several build flags when working with vagrant boxes. As these flags might be different depending on the target OS we will explain only the most important ones.

| Flag                                                       | Type     | Description                                                                                                                                                            |
| -----------------------------------------------------------| ---------| -----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `target-os.major.version` and `target-os.minor.version`    | integer  | Used to specify the version digits of OS version which are separated into digits like `7.8` for an Debain Wheezy release. Both digits have to be specified separately. |
| `target-os.version`                                        | integer  | Used to specify an OS version which is a single integer like `21` for Fedora 21.                              |
| `build.number`                                             | integer  | Will force a certain distribution build number instead of assigning one from the current environment.                                  |
| `appserver.runtime.build`                                  | integer  | Used to specify a certain runtime build to test or package (runtime builds are prepared separately).                                  |
| `github.oauth.token`                                       | string   | A valid GitHub OAuth token used to break the download limit for un-authorized downloads and checkouts on GitHub.                                  |

## Special Flags

There are several special flags which can be passed as build properties using the `-D` parameter.

| Flag                              | Value | Description                                                                                                                                              |
| ----------------------------------| ------| ---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `vagrant-box.error-resistant`     | true  | If this flag is given, the destruction of a box on error will be omitted.                                                                                |

## Examples

### Building within a throw-away vagrant box

Being within the root directory of e.g. [the Debian dist package](https://github.com/appserver-io-dist/debian) a new distribution build can be made as follows:

```bash
ant dependencies-init
ant build -Dtarget-os.major.version=8 -Dtarget-os.minor.version=0 -Dgithub.oauth.token=<YOUR_GITHUB_API_TOKEN>
```

This will result in the following steps:

1. This package will get downloaded along with other dependencies the dist package might have
2. Vagrant will start a Debian Jessie box (downloaded from http://boxes.appserver.io/)
3. ANT will SSH into the machine and issue the `local-build` command within it
4. The Debian box will be destroyed on error or success

All results of the build process will be available within the `build` directory of the distribution package.

### Testing within a stable vagrant environment

Being within the root directory of e.g. [the Fedora dist package](https://github.com/appserver-io-dist/fedora) testing a build can be done as follows:

First we have to get the build artefacts we do want to test. So please download or copy those artefacts into the `build` folder within your dist package root directory.
Its content might look like the following then:

```bash
-rw-r-----@ 1 nobody  staff   3137578  3 Jul 09:02 appserver-dist-1.0.6-5.fc21.x86_64.rpm
-rw-r-----@ 1 nobody  staff  26321634  2 Jul 19:42 appserver-runtime-1.0.7-45.fc21.x86_64.rpm
```

After ensuring we have something to test we can run the actual test commands.

```bash
ant dependencies-init
ant start-vagrant-test-box -Dtarget-os.version=21
ant vagrant-run-tests -Dtarget-os.version=21 -Dvagrant-box.error-resistant=true -Dbuild.number=5 -Dappserver.runtime.build=45 -Dgithub.oauth.token=<YOUR_GITHUB_API_TOKEN>
```

This will result in the following steps:

1. This package will get downloaded along with other dependencies the dist package might have
2. Vagrant will start a Fedora 21 box
3. ANT will SSH into the machine and issue the `local-run-tests` command within it
4. The output of the tests will be prompted to `stdout` and `stderr` on error

Special about this command sequence are three things:

- The machine gets started separately from the test command. This way it will not get destroyed after the test run
- The usage of the `vagrant-box.error-resistant` flag, which preserves the box even on test errors to allow for further investigations
- The build numbers of the dist and runtime builds have to be explicitly specified so the test does not assume its own environment

# Dependencies

As we wrap certain functionalities we do have depencies in your system.
To fully use this package you should at least have the following ready at your workstation:

- [Apache ANT](http://ant.apache.org/) (>= 1.8.3)
- [git](http://git-scm.com/)
- [vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

We also use boxes we packaged ourselves (but you might also chose to do otherwise). For EULA and license restrictions we do not offer Mac OSX and Windows boxes, other boxes will get downloaded from http://boxes.appserver.io/ automatically.
