# Ruby-Rake-script
Rake script for downloading the assembly and removing docker docs ee, regardless of version. 

And in a separate file there is an implemented test date that is imported into the rake script. 

Downloal command: rake docker:pull_and_run_container --trace. 

Removing command: rake docker:remove_image[Version]. 

If the version is not specified, the default value (latest) will be used.
