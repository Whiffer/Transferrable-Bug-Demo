# Transferrable-Bug-Demo

This minimal example project was created to reproduce an apparent macOS Sequoia bug when dragging and dropping Custom Types with Transferrable Protocol.

## Steps to Reproduce

### Steps to run on macOS Sonoma where everything works as expected.

- Compile and run the project as-is on macOS Sonoma and then Tap the '+ Add Item' button a few times to create a couple of Items.

- Select and drag one or more List Rows and then:
1) drop them onto the .dropDestination() modifier Target at the bottom (works as expected)
2) drop them onto the .dropDestination() modifier on any Row in the List (works as expected)
3) drop them between two Rows in the List using the .onMove() modifier (works as expected)



### Steps to Reproduce on macOS Sequoia with .onMove() modifier present

- Compile and run the same project as-is on macOS Sequoia and Tap the '+ Add Item' button a few times to create a couple of Items.

- Select and drag one or more List Rows and then:
1) drop them onto the .dropDestination() modifier Target at the bottom (fails with the error below)
2) drop them onto the .dropDestination() modifier on any Row in the List (fails with the error below)
3) drop them between two Rows in the List using the .onMove() modifier (works as expected)

### The following error is displayed on the debug console for each Item being dragged:

Error loading
com.Demo.persistentModelID:
Error Domain=NSItemProviderErrorDomain Code=-1000 "Cannot load representation of type com.demo.persistentmodelid" UserInfo={NSLocalizedDescription=Cannot load representation of type com.demo.persistentmodelid, NSUnderlyingError=0x6000024c0810 {Error Domain=NSCocoaErrorDomain Code=3072 "The operation was cancelled."}}
Error loading PersistentIdentifier: The operation couldn’t be completed. (CoreTransferable.TransferableSupportError error 0.)



### Steps to Reproduce on macOS Sequoia after removing .onMove() modifier

- Comment out or delete the .onMove() modifier from the ForEach statement.
- Compile and run the edited project on macOS Sequoia 

- Select and drag one or more List Rows and then:
1) drop them onto the .dropDestination() modifier Target at the bottom (now works as expected)
2) drop them onto the .dropDestination() modifier on any Row in the List (now works as expected)



## Conclusion

The errors only seem to occur when an .onMove() modifier and a .dropDestination() modifier are both present in the same View. If used by themselves, they work properly.
