# configure_cma

A front end application for configung and monitoring [DataServer][1] instance.
Written in Flutter.

## Features
 - Viewing and editing the [DataServer][1] configuration parameters in the table representation;
 - Updating the DB section by importing of the S7 data block configuration in the DB format;
 - Saving hole edited/updated configuration to the [DataServer][1] parse.json file;
 - Live monitoring of the configured data points values

## Engineering steps
 - [DataServer][1] developer prepare the parse.json file for the project
 - Automation engineer verifying prepared configuration file parse.json
 - Automation engineer updating prepared configuration using import of the DB files for each data block
 - [DataServer][1] developer aplying updated configuration file to the [DataServer][1]


[1]: https://github.com/a-givertzman/s7-data-server
