# McAfee ATD Content Downloader

If you have one or more McAfee Advanced Threat Defense appliances, you may need to take care of their content updates. If your ATD machines have unrestricted internet access, they may get the updates by themselves, but if not - you may need to get them updated manually. The catch here is that unlike any other products, the ATD machines content is generated for you on-demand and is not available directly in a constant known url / path.

This script follows the content-download wizard and downloads theupdates content file automatically.

## How to use it?

Just run the script using an "internet-accessible" computer, when it finished you'll find a file named "matd-definitions.upd" on the script-runtime-path.

If (for any reason) you want to get the content file manually, you can get it from [here](https://contentsecurity.mcafee.com/update).
