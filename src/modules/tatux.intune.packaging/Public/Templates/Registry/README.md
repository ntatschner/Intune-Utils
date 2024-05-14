# Registry Key Management Guide
### Requirements
#### Key Data
When providing the values you're trying to add, remove or modify in either the commandline paremeter or editing the CSV file in the output directory you must supply the following information in this spcific order. 

| Key Path(RegistryPath) | Key Name(KeyName) | Value Name(ValueName) | Value Type(ValueType) | Value Data(ValueData) | State(State)  |
| :------------ | :----------------- | :-------------------- | :----------------- | :----------- | :------- |
| **HKEY_LOCAL_MACHINE\Software\\** | MySoftware | MyName | DWORD | Setting1 | **ADD**<kbd>*[1]</kbd>

[1] Availible States: ADD, REMOVE or MODIFY

#### Parameter
Use the *-RegistryValue* parameter to specify the registry item at the commandline. As above.
```
-Parameter "HKEY_LOCAL_MACHINE\Software\,MySoftware,MyName,DWORD,Setting1,ADD"
```
#### State Value
The state value should be pretty self explanitory, it's used to either "ADD", "REMOVE" or "MODIFY" the supplied key info, the logic around what happens if a conflict occers is based on the supplied value. 

##### ADD
If a key is found with the **EXACT**(Excluding *ValueData*) details you supplied then the operation is aborted and nothing is added. 
##### REMOVE
It removes the key as supplied and if nothing is found, nothing is removed. 
##### MODIFY
The "ValueData" of the supplied key is modified, if nothing is found it acts as the ADD state.