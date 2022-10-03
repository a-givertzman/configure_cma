# configure_cma

A front end application for configung and monitoring [DataServer][1] instance.
Written in Flutter.

## Features
 - Viewing and editing the [DataServer][1] configuration parameters in the table representation;
 - Updating the DB section by importing of the S7 data block configuration in the DB format;
 - Saving hole edited/updated configuration to the [DataServer][1] [conf.json][2] file;
 - Live monitoring of the configured data points values

## Engineering steps
 - [DataServer][1] developer prepare the [conf.json][2] file for the project
 - Automation engineer verifying prepared configuration file [conf.json][2]
 - Automation engineer updating prepared configuration using import of the DB files for each data block
 - [DataServer][1] developer aplying updated configuration file to the [DataServer][1]


[1]: https://github.com/a-givertzman/s7-data-server
[2]: https://github.com/a-givertzman/s7-data-server/blob/DsDataPoint-history-alarm-attributes/conf.json
