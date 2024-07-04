README

### Démo

|Creating first task|Slide to validate|Search|Filters|Adding details|
|----|----|----|----|----|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-07-04 at 08 29 46](https://github.com/temp-tech-tests/Todoliti/assets/174637846/a77422ef-ad6a-446e-9e05-3b913677fe01)|![Simulator Screen Recording - iPhone 15 Pro - 2024-07-04 at 08 29 01](https://github.com/temp-tech-tests/Todoliti/assets/174637846/c6a0c01d-11cc-48d0-a7bc-16e40f72daa7)|![Simulator Screen Recording - iPhone 15 Pro - 2024-07-04 at 08 30 26](https://github.com/temp-tech-tests/Todoliti/assets/174637846/f5e7b876-4838-4daa-a1d0-0ed92f9467ef)|![Simulator Screen Recording - iPhone 15 Pro - 2024-07-04 at 08 32 13](https://github.com/temp-tech-tests/Todoliti/assets/174637846/ee809c50-5100-4ad8-b660-78427cb5f37a)|![Simulator Screen Recording - iPhone 15 Pro - 2024-07-04 at 08 33 24](https://github.com/temp-tech-tests/Todoliti/assets/174637846/18650503-4e66-4d31-be5d-b1a0cf2eb186)|



### Architecture

The project is divided into two parts. A main application handle business logic and UI and a separate layer for data persistence.

The service Layer is fully reusable and documented. Also fully tested and production ready.

I made this choice to setup this layer in a Package for a few reasons:
⁃ Benefit from access control. This allows to setup well segregated APIs. Allows for a physical split between service objects and business objects
⁃ Reusability. since the module is self contained and fully featured it can be plug in to another app easily and easily distributed as well.
⁃ App is agnostics of storage infrastructure. The package is fully asynchronous so is the wiring in the app side. Therefore should we need to migrate to a remote data source or combien local storage with a remote data source it would be easy to do.

On the app side, the service is wrapped into a manager which isolates TodoService dependency and ensures decoupling of business logic and service layer.

The app is build with the latest stable version of SwiftUI. Since the minimum deployment target was not mandatory I set to iOS17 allowing me to leverage full SwitUI potential.
I like to split my views into separate files as much as possible/relevant.
I make a great usage of previews to test out various co figuration of my views. I tend to say that previews really are UI tests. Using them to their full capabilities help fostering development and permit a certain degree of stability in continuous integration.

I used a simple MVVM pattern to communicate between my views and the service layer. I believe it a good fit for our use case here yet other patterns like MV or MVP should work as well. Using ViewModels though helps with unit testing.

All my layers allow for dependency injection allowing easy mocking for testing and for previews as well.

### Design

I choose to use Apple built in design system which offers free dark mode, information hierarchy, buttons and table view style.

We could later on setup a custom design system with more refined UI elements.

For the sake of simplicity and feature demonstration I believe this is enough.

### Git-flow

I often choose a git flow for front end development. Here I have a master branch which reflect the production and a development branch which holds on going development. I didn’t do any feature branch in this project since I work on my own. This setup allows for a clear and robust release train.

### What to do next

With a little more time I would:

- Set up the model so that the user can schedule local notifications.
- Improve the UI y setting up a bespoke Design System instead of Apple’s stock one.
- Set-up a model that can handle subtasks.
- Setup a remote data base in cloud kit or using GCP for instance.
- More refined error handling, since we only have a generic error for now.
- Proper task cancellation logic especially with a remote data source
- More thorough testing on viewmodels.
