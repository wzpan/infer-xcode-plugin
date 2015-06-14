infer-xcode-plugin
===

This plugin add a menu item for your xcode to quickly excute [facebook infer](http://fbinfer.com) for static analyzing your projects.

> This plugin is still under development. Welcome to send me patch.

## Dependencies

* Xcode 5 above
* infer

## Install

1. Clone the repo and build it.
2. infer.xcplugin should appear in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`
3. Restart Xcode

If you encounter any issues you can uninstall it by removing the `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/infer.xcplugin`.

## Usage

1) Create the infer command script for your project *e.g.* :

``` plain
cd $1  # Must have for now
LOCATION_OF_INFER -- xcodebuild -target TARGET_NAME -configuration Debug -sdk iphonesimulator  
```

Save it to `YOUR_PROJECT/scripts/infer_commands.sh` .

Notice:

1. For the moment, the first command `cd $1` is needed. DO NOT REMOVE IT!
2. `LOCATION_OF_INFER` is needed to be changed to the real location of infer.

2) Open your projects, and click menu Product->Infer to analyze your project.

You can view the result at Console.app by filtering `infer` . 