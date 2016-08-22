# stashmob
Text or email you friends links to Google Places.

### Installation
````
git clone git@github.com:hatebyte/stashmob.git && cd stashmob && pod setup && pod install && open StashMob.xcworkspace
````

Too use, replace the user defined keys with your own bundle id and api keys
<img src="http://i.imgur.com/VzBKqcG.png" height="130">


###All requirements have been fulfilled  
- [x] List a user’s contacts from their phone  
- [x] Send and receive Google Place information to any of a user’s contacts  
(share through email, sms, etc)  
- [x] For each of a user’s contacts, maintain the history for each place sent
to or received from that user.  
- [x] Allow users to view details of places  
- [x] Include deep-links in messages in order to display received Place  
information, or to navigate to relevant sections of the app.  
- [x] Allow users to view selected places as markers on Google Maps.  
- [x] Include an autocomplete search bar for places  

### Notes

This app demonstrates the design principles that are important to me.
Namely, decoupling of implementation through protocols. The app passes structs as model currencies. CoreData and the AddressBook frame work communicate to the app through these structs. This allows flexiblity in the future. 

If we want to replace CoreData or the AddressBook in the future, we can write new implementations and the rest of the app would not be effected. 
