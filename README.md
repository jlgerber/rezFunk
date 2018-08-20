# rezFunk
cmake functions for rez. The main one being a function to trigger cargo builds for rez, since cmake doesnt have native support for rust yet.

To use with rez, release the package, then list as a build dependency.
You should be able to include it via ```include(RezBuildRust)```
