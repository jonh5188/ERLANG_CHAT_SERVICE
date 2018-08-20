-module(chat).
-export([run/0, master/0, user/0, connect/0]).

run() ->
     spawn(chat, master, []).     

master() ->
     receive
         {create, Username} ->
          register(Username, spawn(chat, connect, [])),
          io:format("Created the username: ~p~n", [Username]),      
          master()
     end.			              

user() ->
     receive
          {disconnect, offline} ->
               io:format("Now offline...~n"),
               exit(kill),
               connect();
          {From, Message} ->
               io:format("~p :", [From]),
               io:format(" ~p~n", [Message]),
               user();
          _ ->
               io:format("User is no longer online~n"),
               user()
     end.

connect() ->
     receive
          {connect, online} ->
               io:format("Now online...~n"),
               user();
          _ ->
               io:format("Not connected~n")
     end.