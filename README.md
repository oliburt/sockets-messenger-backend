# Sockets-Chat

Sockets chat is an instant messaging app. As a user you can view and message public Chatrooms or create your own. You can also directly message other users as a direct message which is private to the two people involved. This repo is only for the backe end of the application. You can find the front-end here: [Frontend-Repo](https://github.com/oliburt/sockets-messenger-frontend)

Here is a link to a live (frontend) version: [Demo](https://s-chat-app-frontend.herokuapp.com/)

## Prerequisites

This was built on macOS.

In order to run this project on your own machine you will need first need Ruby and Rails installed. (This was built with Ruby v.2.6.3p62 and Rails v.6.0.1)

You can download and find documentation about the Ruby programming language [here](https://www.ruby-lang.org/en/documentation/). 

To download and find documentation about the Rails Framework you can do so [here](https://rubyonrails.org/). ( Rails is built on Ruby so download Ruby first)

You will also need [postgres](https://www.postgresql.org/) installed locally on your machine to setup the database.

Once you have Ruby and Rails installed you can fork and clone this project to your local machine.

After cloning the project open the main project directory in the terminal and run:
```
$ bundle install
```
to install all gem dependencies.

Then run:
```
$ rails db:create
$ rails db:migrate
```
to create the database and its schema in PostGres.

Then lastly you can run: 
```
$ rails s
```
to spin up the development server on your localhost.

*The back-end has been configured to only accept requests from the live front-end. In order to change this configuration to look in /config/initializers/cors.rb and change the origin urls to your choosing.
For Action Cable in production go to /config/environments/production.rb and change "config.action_cable.allowed_request_origins" and "config.web_socket_server_url" to your choosing.*

*Also in order to get the JWT authentication you will need to create an environment variable called 'RAILS_SECRET'. To set this up, in the config file, create a file named local_env.yml (/config/local_env.yml) and save:*
```
RAILS_SECRET: "[YOUR_SECRET_HERE]"
```
*in the file. /config/application.rb has already been setup to include this in your environment. Then you can access this variable through: ENV['RAILS_SECRET'].
Then do not forget to add the local_env.yml to a .gitignore file so it is not included if you modify and push the project back up to github.*

## Main Features

This project has been setup to serve data to the front-end in JSON format. The API structure follows REST-ful conventions.

### Model setup

For this project there are four models so far.

User model - username:string, password_digest:string (password hash managed by bcrypt gem), and active_user:boolean property to manage the presence of the user on the front-end. (If a private websocket channel is connected for the user then active_user will be set to true and false if that channel is disconnected. This is then broadcasted to every other user who is connected to the 'presence channel')

Chatroom Model - name:string, description:string, public:boolean (if true, a public chatroom can be found by anyone on the frontend, if false the chatroom is private. So far private chatrooms are used for direct messages), and creator_id:integer (this is a sort of foreign key to indicate which user created the chatroom. This does not affect any features in the project at the moment but is to be used for later improvements, such as deleting chatrooms which can only be done by the creator and other possible admin options).

UserChatroom Model - user_id:integer and chatroom:integer. This is purely a join table to manage 'ownership' status of users over chatrooms (like adding a chatroom to 'My Chatrooms')


Message Model - content:string, user_id:intger, chatroom_id:integer.

Users have many messages.
Users have many user_chatrooms.
Users have many chatrooms, through user_chatrooms.

Chatrooms have many messages.
Chatrooms have many user_chatrooms.
Chatrooms have many users, through user_chatrooms.

Messages belong to a user.
Messages belong to a chatroom.

UserChatrooms belong to a user.
UserChatrooms belong to a chatroom.

### Controllers

There is a controller for each of the models to deal with incoming requests plus an Auth-Controller for managing user validations and login/logout actions.

### Auth and Validation

JSON Web Tokens (JWT) has been used to encrypt the user_id when a session begins and is stored in an HTTP-only cookie on the client's machine. Every subsequent request sent by the client includes this cookie and it is then decoded and if the web token is valid (user is found) then the appropriate action is taken. The user is also validated by this cookie before any websocket broadcasts are made.

### Action Cable

This project uses Rails' ActionCable (first introduced in Rails 5) to integrate the websockets protocol to broadcast newly created chatrooms and messages to the correct client's machines. There is also a channel that manages the online/offline presence of users.


## Technology Stack

### Backend

- [Ruby](https://www.ruby-lang.org/en/documentation/)
- [Rails](https://rubyonrails.org/) (Initialized with 'rails new' with '--api' flag)
- [Postgres](https://www.postgresql.org/)
- [Redis Gem](https://github.com/redis/redis-rb) for Action Cable in production
- Action Cable for WebSockets Protocol
- Active-Model-Serializers for data serialization
- Bcrypt for password authentication
- Rack-Cors for CORS
- JWT for user Auth (stored in an HTTP-Only Cookie)

### Frontend - [Front-end Repo](https://github.com/oliburt/sockets-messenger-frontend)

- JavaScript
- HTML
- CSS
- [Node.js]((https://nodejs.org/en/)) + NPM
- React (This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app))
- [Redux](https://redux.js.org/) + [Redux Devtools](https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en) + [Redux Thunk](https://github.com/reduxjs/redux-thunk)
- [React Router Dom](https://reacttraining.com/react-router/web/guides/quick-start)
- [React Scroll to Bottom](https://github.com/compulim/react-scroll-to-bottom)
- Rails' [ActionCable](https://www.npmjs.com/package/actioncable) package
- Some styling done with [Semantic-UI-React](https://react.semantic-ui.com/)
- Deployed using [Heroku](https://www.heroku.com/platform)

## Future Development Plans

- Removing Chatrooms from 'My Chatrooms'
- Deleting a Chatroom (if you are the creator)
- Deleting direct messages
- Clicking on a user in a chatroom to get the option to DM them
- Creator of a chatroom able to have admin priveleges over a chatroom. E.g. Only allowing specific users to join, removing people etc.
- Deleting your account.
- Better validations/security for signing up. (At the moment, passwords only need to match and usernames must be unique)
- Editing account info (username and password)
- Notifications for unread messages
- Profile pictures
- Tests
- More to come...

## Author

Oliver Burt