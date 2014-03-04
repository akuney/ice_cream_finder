Ice Cream Finder
================

By Andre Kuney and Mickey Sanchez

This program takes in a location (given by a street address) and returns a list of the ice cream shops within a user-entered number of meters. If the user then picks one of them, they can get directions from their current location to that ice cream shop.

This is done by using three Google Maps API's: geocode (to turn the given address into coordinates), nearbysearch (to find the ice cream places using Google search), and directions. Various Ruby gems helped us out.

The meat of the project consisted of looking at the params found in the API and figuring out how deep the necessary information was. It was instructive as to how 3rd-party API's work.

