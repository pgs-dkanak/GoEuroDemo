
# GoEuro Demo
Code Challenge to show travel data

XCode Version that used for this project: 8.3.2 

# Architecture

Architecture chosem is MVVM with main view model for main view and list of individual view models for each displayed cell

Project is thoroughly Unit-Tested

Project uses Dependency Injection for API managment object

For global settings static class is used. This avoids singleton initialisation problems. Sigletons are not on board and not welcome in this project.

For separate interfaces communication is protocol-based

Communication between ViewModel and ViewController is direct when ViewController calls ViewModel. In other way round ViewModel -> ViewController communication is indirect via RxSwift Observables. Signals occur when ViewModel broadcasts events of internal application Model state changed.

Model is decoupled from surrounding classes and can be used separately

Project is written with guidelines of SOLID (SRP, OCP, LSP, ISP, DIP). Whenever these guidelines were violated or adjusted to project's specific needs, motivation behind this decision was explained in the comment.


## 3rd party dependencies

This project using CocoaPods as dependency management.

List of 3rd Party that used: 
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [RxSwift](https://github.com/ReactiveX/RxSwift)

Rx is a generic abstraction of computation expressed through Observable<Element> interface.
This is a Swift version of Rx.

Alamofire used as HTTP Networking Library 

