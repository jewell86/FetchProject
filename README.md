# FETCH PROJECT README

## Build tools & versions used
Built by Jewell Braden, ©2024
iOS 15, Xcode 15.3

## Steps to run the app
Because there are no third party dependencies, running the app is simple! Once you've got it open in Xcode, just press the play button and it'll boot right up. 
    - Pull to refresh the view!

👉 Note - the endpoints called upon app launch & refresh are randomized to simulate different responses coming from the 'service'. These responses in turn will simulate a happy path (full tableview with recipes), an empty repository (an empty tableView with a placeholder cell) and a malformed data state (which will throw an error banner on top of whatever view is present). In order to only call the happy path endpoint, in the Service class, on line 13, paste in this code: `var endpoints = [Endpoints.employeeEndpoint]`

## What areas of the app did you focus on?
I focused mainly on the architecture and design of the app. It's a small project, so I probably overengineered it. I wrote it this way as an example of how I like to design a project, and how it might look if I were creating an app with the intention to scale it. I also focused on the unit testing, although there was more I'd like to add. 

## What was the reason for your focus? What problems were you trying to solve?
I'm lucky to work on a team whose codebase is so well structured that it's probably considered over the top. Our test suite is also very robust and covers close to 100% of the codebase's lines. I recently rotated to our Android squad to see what life was like over there, and found that their codebase was not architected super well, and their tests were lacking. 

Because of all that, I really feel strongly that it's important to have a well-structured codebase, with consistent patterns, naming conventions and styling. Once it's written this way, it's easy for any engineer to follow the patterns and maintain the structure. That makes it easy for anyone to contribute code, and quicker to track down bugs. 

## How long did you spend on this project?
Honestly a little longer than I intended to 😬. After the 5-6 hour mark, I decided to spend some more time improving architecture, patterns & styling, and beefing up the tests. 

## Did you make any trade-offs for this project? What would you have done differently with more time?
I decided against using SwiftUI and 3rd party dependencies for this project and would add them if I had more time. I really love SwiftUI because of it's simplicity, but truthfully UIKit is my native language and so I felt more comfortable building a quick UITableView quickly over a List in SwiftUI. As for 3rd party dependencies, I would have used Spry for unit testing, becasue it makes stubbing so much more simple. A couple more things I would have added with more time:
        - Better failure messages for testing failures
        - Created a placeholder view for the empty tableView, instead of extending the UITableViewCell
        - Tested for different sized screens & screen rotation
        - Added more/better accessibility identifiers and features
        - Finished writing all tests
        - Used SwiftUI instead of UIKit

## What do you think is the weakest part of your project?
I think the UI is the weakest part of my project. I didn't spend much time on it at all - as soon as I got the table view up and running, I did a little bit of spacing to make everything align and called it good. 

## Did you copy any code or dependencies? Please make sure to attribute them here!
I didn't, but I definitely relied on google, stackoverflow & Apple docs for quite a few things 😅

## Is there any other information you’d like us to know?
This was really fun! It's been a long time since I've spun up an app from scratch and I really enjoyed building this. Thanks for your time, and I hope I get a chance to work on expanding the app with your team!
