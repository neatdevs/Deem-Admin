# Deem Admin

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/neatdevs/Deem-Admin/refs/heads/main/admin.lua"))()
```

Deem Admin is a modular based admin system that works with legacy chat system or by UI. Due to this Deem only has a select few amount of built in commands, and they are all universal and needed.

# How to add a command to Deem admin

A folder named "Deem_commands" will be created upon execution.
To create a plugin you will need to create a new file such as .lua.
Deem admin will treat every lua file within the folder as a function, whatever is inside the file is what is gets ran whenever you execute the command.
The name of the file will be what the command is called for example if the file is named HelloWorld.lua or HelloWorld.txt to run the command you would type HelloWorld in the input, commands are not case sensitive therefore you could also type HeLLoWoRLd and the command would still run.

# Note.

Deem Admin has only been tested on the windows executor called "Sirhurt", some exploits may not be support but most will.
Deem Admin also requires read & write file functionality for full support if you're exploit doesn't support said functions the script may not work as intended.
