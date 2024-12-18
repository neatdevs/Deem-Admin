## Deem Admin

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/neatdevs/Deem-Admin/refs/heads/main/admin.lua"))()
```

**Update notication/changelogs**

  If you want to be updated every time Deem Admin updates then please be sure to join our discord as it's our main way of getting the lastest news from the team at Deem
  The link can be found here: discord.gg/su7ycRRJyz

---

Deem Admin is a modular admin system compatible with the legacy chat system or UI. It includes only essential universal commands by default.

---

### Adding Commands to Deem Admin

Upon execution, a folder named `Deem_commands` will be created. To add a custom command:

1. **Create a File**: Add a new `.lua` file to the `Deem_commands` folder.  
   - Deem Admin treats each `.lua` file as a separate command.

2. **Define Command Logic**: Write the desired functionality inside the file.

4. **Name the File**: The file's name becomes the command's name.  
   - Example: A file named `HelloWorld.lua` creates a `HelloWorld` command.

5. **Run the Command**:  
   - Type the file name (e.g., `HelloWorld`) in the input to execute it.  
   - Commands are **not case-sensitive** (e.g., `HeLLoWoRLd` will also work).

6. **Always in include the return**
   - If you do not include the return as the code part of the codde it won't execute and outputs an error.

Example command/plugin for reference:

```lua
return function(args)
    print("TestCommand executed with args: " .. args)
end
```

---

### Notes

- **Compatibility**:  
  Deem Admin has been tested with the Windows executor *SirHurt*. While most exploits should work, some may not be fully supported.
  
- **File Access Requirements**:  
  The script requires **read and write file functionality**. If your exploit lacks these features, the script might not function correctly.
