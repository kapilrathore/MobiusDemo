# MobiusDemo
A demo application with my flavour of Mobius Architecture (Spotify)

# About Mobius Architecture
A Mobius loop receives Events, which are passed to an Update function together with the current Model. As a result of running the Update function, the Model might change, and Effects might get dispatched. The Model can be observed by the user interface, and the Effects are received and executed by an Effect Handler.

# Inspired by
Great talk on mobius architecture by Petter Måhlén
https://www.youtube.com/watch?v=j7Fi64ZP0S8&t=734s
