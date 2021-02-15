# CoreDataLayer


Abstraction layer between the business layer and the storage layer using CoreData, based on the Repository pattern, presented within a demo application.

This implementation is structured in the following layers:
    1. XCDataModelId - Model file that defines the app's object structure
    2. CoreDataStore - Initializes a NSPersistentContainer object and provides: a view and private context; a save method to save all the changes made on the persistence layer
    3. ObjectRepository - any object of this type extends the CoreDataRepository base class and provides open methods to add, get, update or delete any managed object from the persistence layer
    4. ObjectService - it is the top most layer of the persistence stack and the one that rest of the app will interact with in order to make any changes on the persistence layer. 


