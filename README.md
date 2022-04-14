# AriadNextMessage

## Introduction
AriadNextMessage is a basic client-server communication application.

This application was designed as a messaging service with a robot that is there to help us.
The client will send his message, the robot will then take some time to send back a response. This answer will refer to the client request, either by quoting it entirely or partially.

## Development

I chose to implement the architecture in **MVVM-C**. Even though the application currently only has one screen, having the coordinators already present will make it easier to add new features.

I started my development by setting up the architecture. Once done, I started designing the interface by mocking my data.
To realize the server part, having never used/realized a server in Swift, I preferred to look for a library.
I tested several (Vapor, Swifter, Kitura, ...) before finding the one that suited me the most in relation to what I wanted to achieve. So I used the [FlyingFox library](https://github.com/swhitty/FlyingFox), it's a small library but it keeps up to date. It therefore makes it possible to launch an HTTP server, to add routes to it and to indicate what these routes will return.

With more time I would have developed the server part myself, but having never practiced I preferred to use a library.


## Organisation
Given the _"simplicity"_ of the project, I would have simply divided the work into two tasks. One to build the server and the other to build the interface.

Regarding the code review, I should have made a first commit on main with the whole structure of the project, to lighten my pull request a bit, sorry.

## Total time
I think I spent about 10 hours developing the project (including at least 1 hour of testing/downloading libraries).
