%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% game.pl  
%
% Use this as the starting point for your game.  This starter code includes
% the following:
%  - Some example areas
%  - An example of how you might connect those areas 
%  - Handling of the actions 'go _______.', 'help.', and 'quit.'
%  - Basic game loop
%  - Input processing which strips case and punctuation and puts the words into a list 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Facts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(readln)).

% Dynamic fact used to store the player's current location
:- dynamic currentArea/1.

% Dynamic fact used to sotre players's inventory
:- dynamic inventory/1.	

% Assert this dynamic fact to stop the game once the player has won (or lost!) 
:- dynamic gameOver/0.

% Defining items
item(key, ' There is a key on the floor which might be helpful later.').
item(eagle, ' There is an Eagle walking on the ground. ').
item(tiger, 'Tigeres').
item(bear, ', Bears, ').
item(helmet, ' By your feet you find a beat up helmet.').
item(shoes, ' On the ground are some shoes you might need.').
item(sword, ' There is a sword layind on the ground, it could be useful in your fights.').
item(cage, ' On the floor you find a cage. ').
item(gladiator, ' Choose who you want to fight. ').
item(spartacus, '').
item(commodus, '').
item(flamma, '').
item(shield, ' On the floor you find a shield you can use to defened your self.').
item(food, ' You are very hungry and week and could use something to eat.').
item(meat, ' There is some meat laying on the ground.').
item(gold, 'You have found the GOLD, Congradulations you Win!!!').
item(ancientLock, 'Type open chest to try and open it. ').
item(insideDoor, ' There is a door ahead.').
item(gobackDoor, ' There is a door to take you back.').
item(winner, '').
item(fed, '').

% Describing the properties of items
edible(food).

pickup(meat).
pickup(key).
pickup(cage).
pickup(sword).
pickup(shoes).
pickup(helmet).
pickup(eagle).
pickup(shield).

feedable(meat).

fightable(commodus).
fightable(spartacus).
fightable(flamma).

% Location of where the items are in the rooms
:- dynamic location/2.

location(key, colosseum).
location(insideDoor, waterTunnel).
location(helmet, waterTunnel).
location(tiger, animalCages).
location(gobackDoor, animalCages).
location(bear, animalCages).
location(eagle, animalCages).
location(insideDoor, dirtTunnel).
location(meat, dirtTunnel).
location(gobackDoor, gladiatorRoom).
location(cage, gladiatorRoom).
location(gladiator, gladiatorRoom).
location(spartacus, gladiatorRoom).
location(commodus, gladiatorRoom).
location(flamma, gladiatorRoom).
location(insideDoor, bridge).
location(shoes, bridge).
location(insideDoor, stairs).
location(sword, stairs).
location(gobackDoor, emperorRoom).
location(food, emperorRoom).
location(shield, emperorRoom).
location(gobackDoor, snakeRoom).
location(ancientLock, snakeRoom).
location(gold, treasureChest).
location(winner, gladiatorRoom).
location(fed, animalCages).

% Here is one way you might create your areas
area(colosseum, 'Start Area', 'You have been telleported back in time to 80 A.D. into a Roman Colosseum.  You are standing in the middle of the ring with thousands of people watching and screaming for a fight. You weren\'t prepared so you have no weapons on you. There are rooms in each direction, go find some armor!').
area(waterTunnel, 'Second Area', 'You find yourself in a poorly lit place with dirty body of water running between you and the next room.  There is an old man sitting on a boat wating to transport you should you choose to keep going or you can go back south.').
area(animalCages, 'Third Area', 'Now is the time to fear.  You have entered the animal cages.  The lighting is poore and at some places is pitch black.  There is constant aniaml roars and screams. The animals are hungry, and ready to break through the cages.  You would be smart to find some meat for them otherwise you will become dinner. Some of the animals there are: ').
area(bridge, 'Fourth Area', 'You enter on to an old flimsy bridge. Beneath the bridge you see crocodiles. With every step it seems as if the boards will break watch your step. There is another room at the end of the bridge should you choose to go on or you can go back north.').
area(snakeRoom, 'Fifth Area', 'You find your self in a room full of snakes.  You happen to be alergic to snakes and know that if one of them bites you that will be the end of you.  In this situation an eagle and a key to unlock the treasure chest is helpful. ').
area(gladiatorRoom, 'Sixth Area', 'Alas you have made it into the basic gladiator training room.  The room smells of sweaty man and is covered with what looks like blood stains on the floor.  You begin the traning and it is coming very natural to you due to your ability to learn new things in no time. In the room are three great gladiators Spartacus, Flamma and Commodus.').
area(dirtTunnel, 'Seventh Area', 'You have entered in to a dirt tunnel.  It is very muddy and cold inside and smells of roten food.  There is no lighting but you can see a light at the end of a tunnel that leads to another room if you keep going west or you can go back east.').
area(stairs, 'Eigth Area', 'You enter into a nice spiral stairway.  At the top you can hear beatiful music playing and some laughter or you can go back west.').
area(emperorRoom, 'Ninth Area', 'You have entered into the Emperors room.  It is filled with different types of food and music.  The room is very bright due to the great balcony that looks over the Colosseum.  The Emperor is drunk and mistakes you for one of his trusted man and offeres you food.').
area(treasureChest, 'Final Area', 'You have opened the treasure chest : ').

% You might connect your areas like this:
connected(north, colosseum, waterTunnel).
connected(south, waterTunnel, colosseum).

connected(south, colosseum, bridge).
connected(north, bridge, colosseum).

connected(west, colosseum, dirtTunnel).
connected(east, dirtTunnel, colosseum).

connected(east, colosseum, stairs).
connected(west, stairs, colosseum).


% Assigining doors between places 
door(door, waterTunnel, animalCages).
door(door, animalCages, waterTunnel).
door(door, dirtTunnel, gladiatorRoom).
door(door, gladiatorRoom, dirtTunnel).
door(door, stairs, emperorRoom).
door(door, emperorRoom, stairs).
door(door, bridge, snakeRoom).
door(door, snakeRoom, bridge).
door(chest, snakeRoom, treasureChest).

%Putting a lock on a door
:- dynamic locked/1.

locked(chest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handling of the action 'go _______.', and a good example of how you might implement others
processInput([go, Direction]) :-
    currentArea(Current),
    connected(Direction, Current, NewRoom),
    changeArea(NewRoom).
processInput([go, _]) :-
	print(''), nl, nl,
    printinRed('You hit an invisible wall and can\'t go that way'), nl, nl.

% Handling of the action 'pick up _______.',	
processInput([pick, up, cage]) :-
	inventory(winner),
	currentArea(Current),
	location(cage, Current),
	assertz(inventory(cage)),
	retract(location(cage, Current)),
	retract(inventory(winner)), nl, nl,
	printinGreen('You got a cage.  You can go get the eagle now.'), nl, nl.
processInput([pick, up, cage]) :-
	currentArea(gladiatorRoom), nl, nl,
	printinRed('You need to Fight for it first!!'), nl, nl.
processInput([pick, up, cage]) :-
	print(''), nl, nl,
	printinRed('It\'s not here!!'), nl, nl.
processInput([pick, up, eagle]) :-
	inventory(cage),
	inventory(meat),
	inventory(fed),
	currentArea(Current),
	retract(inventory(fed)),
	retract(location(fed, Current)),
	assertz(location(fed, Current)), 
	retract(inventory(meat)),
	assertz(location(meat, dirtTunnel)),
	location(eagle, Current),
	assertz(inventory(eagle)),
	retract(location(eagle, Current)), nl, nl,
	printinGreen('You have picked up an Eagle. '), nl, nl.
processInput([pick, up, eagle]) :-
	inventory(meat),
	inventory(fed), nl, nl,
	printinRed('You need a cage to put the eagle in.'), nl, nl.
processInput([pick, up, eagle]) :-
	inventory(meat),
	inventory(cage), nl, nl,
	printinRed('First feed the meat to the animals.'), nl, nl.
processInput([pick, up, eagle]) :-
	inventory(meat), nl, nl,
	printinRed(' Not yet. You need to find a cage now!!!'), nl, nl.
processInput([pick, up, eagle]) :-
	inventory(cage), nl, nl,
	printinRed('The animalas are hungry, you need to find some meat to feed them bofore you can take the eagle'), nl, nl.
processInput([pick, up, eagle]) :-
	print(''), nl, nl,
	printinRed('You need a cage and meat before you can get the eagle.'), nl, nl.
processInput([pick, up, Item]) :-
	currentArea(Current),
	pickup(Item),
	location(Item, Current),
	assertz(inventory(Item)),
	retract(location(Item, Current)), nl, nl,
	printinGreen('You picked up '),
	printinGreen(Item), nl, nl.
processInput([pick, up, Item]) :-
	pickup(Item), nl, nl,
	printinRed('It\'s not here!'), nl, nl.
processInput([pick, up, _]) :-
	print(''), nl, nl,
	printinRed('I can\'t do that sorry!'), nl, nl.

% Handling of the action 'drop _______.',
processInput([drop, cage]) :-
	inventory(eagle), nl, nl,
	printinRed('You can\'t drop the cage there is an eagle in there.'), nl, nl.
processInput([drop, cage]) :-
	inventory(cage),
	retract(inventory(cage)),
	assertz(location(cage, gladiatorRoom)), nl, nl,
	printinGreen('You doroped the cage so gladiators took it back to gladiator room.'), nl, nl.
processInput([drop, Item]) :-
	inventory(Item),
	currentArea(Current),
	retract(inventory(Item)),
	assertz(location(Item, Current)), nl, nl,
	printinGreen('You droped '),
	printinGreen(Item), nl, nl.
processInput([drop, Item]) :-
	print(''), nl, nl,
	printinRed('I can\'t drop the '),
	printinRed(Item), nl, nl.

% Handling of the action 'invenotry _______.',	
processInput([inventory]) :-
	print(''), nl, nl,
	printinCyan('Contents of your Inventory: '), nl,
	findall(X, inventory(X), Inventory),
	printinCyan(Inventory), nl, nl.

% Handling of the action 'open _______.',
processInput([open, Door]) :-
	currentArea(snakeRoom),
	door(Door, snakeRoom, treasureChest),
	locked(Door), nl, nl,
	printinRed('The treasure chest is locked, try and unlock it.'), nl, nl.
processInput([open, chest]) :-
	currentArea(Current),
	door(chest, Current, LockNext),
	changeArea(LockNext),
	assertz(gameOver).
processInput([open, Door]) :-
	currentArea(Current),
	door(Door, Current, LockNext),
	changeArea(LockNext).
processInput([open, Door]) :-
	print(''), nl, nl,
	printinRed('I can\'t open a '),
	printinRed(Door), nl, nl.

% Handling of the action 'unlock _______.',
processInput([unlock, Door]) :-
  currentArea(Current),
  door(Door, Current, _),
  locked(Door),
  inventory(key),
  inventory(cage),
  inventory(eagle),
  retract(locked(Door)),
  retract(inventory(key)),
  retract(location(ancientLock, Current)), nl, nl,
  printinGreen('You unlocked the treasure chest! Now Open it to see what\'s inside'), nl, nl.
processInput([unlock, Door]) :-
  currentArea(Current),
  door(Door, Current, _),
  locked(Door),
  inventory(key),
  printinRed('You can\'t get close to the chest to unlock it because the snakes are there. Go get an eagle to eat the snakes!'), nl, nl.
processInput([unlock, Door]) :-
  currentArea(Current),
  door(Door, Current, _),
  locked(Door),
  printinRed('You need a key first before you can unlock it!'), nl, nl.
processInput([unlock, _]) :-
  printinRed('Sorry, you can\'t do that here.'), nl, nl.

% Handling of the action 'choose _______.',  
processInput([choose, spartacus]) :-
	assertz(inventory(spartacus)), nl, nl,
	printinGreen('I am Spartacus, get ready for defeat. Lets fight.'), nl, nl.
processInput([choose, flamma]) :-
	assertz(inventory(flamma)), nl, nl,
	printinGreen('I am Flamma, get ready for defeat.  Lets fight.'), nl, nl.
processInput([choose, commodus]) :-
	assertz(inventory(commodus)), nl, nl,
	printinGreen('I am Commodus, get ready for defeat. Lets fight.'), nl, nl.
processInput([choose, Item]) :-
	print(''), nl, nl,
	printinRed('You can\'t choose '),
	printinRed(Item), nl, nl.

% Handling of the action 'fight _______.',
processInput([fight, spartacus]) :-
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet),
	inventory(spartacus),
	currentArea(gladiatorRoom),
	retract(inventory(spartacus)),
	location(winner, gladiatorRoom),
	assertz(inventory(winner)),
	retract(location(winner, gladiatorRoom)),
	assertz(location(winner, gladiatorRoom)),
	retract(location(spartacus, gladiatorRoom)),
	assertz(location(spartacus, gladiatorRoom)), nl, nl,
	printinGreen('There was a tie but the people have choosen you as the victor.  You can get the cage now.'),nl, nl.
processInput([fight, flamma]) :-
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet),
	inventory(flamma),
	currentArea(gladiatorRoom),
	retract(inventory(flamma)),
	location(winner, gladiatorRoom),
	assertz(inventory(winner)),
	retract(location(winner, gladiatorRoom)),
	assertz(location(winner, gladiatorRoom)),
	retract(location(flamma, gladiatorRoom)),
	assertz(location(flamma, gladiatorRoom)),  nl, nl,
	printinGreen('The fight was long but you won.  You can get your cage now.'),nl, nl.
processInput([fight, commodus]) :-
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet),
	inventory(commodus),
	currentArea(gladiatorRoom),
	retract(inventory(commodus)),
	location(winner, gladiatorRoom),
	assertz(inventory(winner)),
	retract(location(winner, gladiatorRoom)),
	assertz(location(winner, gladiatorRoom)),
	retract(location(commodus, gladiatorRoom)),
	assertz(location(commodus, gladiatorRoom)), nl, nl,
	printinGreen('The blood was shed but you have won.  You can get the cage now.'),nl, nl.
processInput([fight, Item]) :-
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet),
	fightable(Item),
	currentArea(gladiatorRoom),nl, nl,
	printinRed('You need to choose the gladiator first.!'), nl, nl.
processInput([fight, Item]) :-
	fightable(Item),
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet), nl, nl,
	printinRed(' You are not permitted to fight here!!!'), nl, nl.
processInput([fight, Item]) :-
	fightable(Item), nl, nl,
	printinRed('You don\'t have all your equipment. GO find the rest of it. '), nl, nl.
processInput([fight, Item]) :-
	inventory(sword),
	inventory(shield),
	inventory(shoes),
	inventory(helmet),
	fightable(Item),
	currentArea(gladiatorRoom),nl, nl,
	printinRed('You need to choose the gladiator first.!'), nl, nl.
processInput([fight, Item]) :-
	print(''), nl, nl,
	printinRed('You can\'t fight '),
	printinRed(Item), nl, nl.

% Handling of the action 'eat _______.',
processInput([eat, Item]) :-
	edible(Item),
	currentArea(emperorRoom),
	retract(location(food, emperorRoom)), nl, nl,
	printinGreen('The was yummy.  Thank you!'), nl, nl.
processInput([eat, Item]) :-
	edible(Item), nl, nl,
	printinRed('I would love to eat '),
	printinRed(Item),
	printinRed(' but there is none around me. Go find it first.'), nl, nl.
processInput([eat, Item]) :-
	print(''), nl, nl,
	printinRed('Sorry i can\'t eat '), 
	printinRed(Item), nl, nl.
	
% Handling of the action 'feed _______.',
processInput([feed, Item]) :-
	inventory(cage),
	feedable(Item),
	inventory(Item),
	currentArea(animalCages),
	assertz(inventory(fed)),
	retract(location(fed, animalCages)),
	assertz(location(fed, animalCages)), nl, nl,
	printinGreen('The animals are full and fell asleep. You can get the eagle now.'), nl, nl.
processInput([feed, Item]) :-
	feedable(Item),
	inventory(Item),
	currentArea(animalCages),nl, nl,
	printinRed('You need to get a cage first.'), nl, nl.
processInput([feed, Item]) :-
	feedable(Item),
	inventory(Item), nl, nl,
	printinRed('You can\'t feed in this area.'), nl, nl.
processInput([feed, Item]) :-	
	print(''), nl, nl,
	printinRed('You can\'t feed '),
	printinRed(Item), nl, nl.

% Add some help output here to explain how to play your game
processInput([help]) :-
	print(''), nl, nl,
	printinBlue('Welcome to the Roman Empire the most dangerous experience of your life. You find your self in the middle of a Roman Colosseum trying to survive as a new gladiator with nothing but the cloths on your back.  The new world you live in consists of the Colosseum and all of its underground rooms such as the animal room, gladiator room, Emperor room and the snake room.  It is a very dangerous world for a young Gladiator like you.   You will gather new weapons and fight for survival against other Gladiators to survive.  Upon victory in a fight you will get the chance to get the gold through a series of quests.  Will you succeed in becoming the most fearless Gladiator of all and getting the gold? Or will you fall like many others did? Lets find out what your made of: '), nl, nl,
	printinBlue('Valid Input is:'), nl,
	printinBlue('   go {direction}.  -  takes you to a different room'), nl,
	printinBlue('   pick up {item}.  -  picks up an item and places in the players inventory'), nl,
	printinBlue('   drop {item}.     -  drops the item from players inventory'), nl,
	printinBlue('   inventory.       -  displays your inventory'), nl,
	printinBlue('   open {door}.     -  opens the door and goes inside'), nl,
	printinBlue('   unlock {door}.   -  unlocks a door if you have a key'), nl,
	printinBlue('   eat {item}.     -  eats an item'), nl,
	printinBlue('   fight {item}.      -  fights a gladiator'), nl,
	printinBlue('   choose {gladiator}.    -  choose\'s a gladiator to fight'), nl,
	printinBlue('   feed {item}.    -  feeds the animals'), nl,
	printinBlue('   help.            -  show\'s this file'), nl, nl.

% Catch-all for unknown inputs - make sure all of your processInput rules are above this one!
processInput(_) :-
	print(''), nl, nl,
    printinRed('I don\'t know how to do that...try something else'), nl, nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Basic Gameplay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This rule starts everything off
play :-
    retractall(gameOver),
	retractall(currentArea(_)),
    assertz(currentArea(colosseum)),
	
	retractall(inventory(_)),
	
	retractall(location(key, _)),
	retractall(location(helmet, _)),
	retractall(location(eagle, _)),
	retractall(location(tiger, _)),
	retractall(location(bear, _)),
	retractall(location(meat, _)),
	retractall(location(cage, _)),
	retractall(location(gladiator, _)),
	retractall(location(shoes, _)),
	retractall(location(gold, _)),
	retractall(location(sword, _)),
	retractall(location(food, _)),
	retractall(location(shield, _)),
	retractall(location(spartacus, _)),
	retractall(location(commodus, _)),
	retractall(location(flamma, _)),
	retractall(location(winner, _)),
	retractall(location(fed, _)),
	
	assertz(location(key, colosseum)),
	assertz(location(helmet, waterTunnel)),
	assertz(location(tiger, animalCages)),
	assertz(location(bear, animalCages)),
	assertz(location(eagle, animalCages)),
	assertz(location(meat, dirtTunnel)),
	assertz(location(cage, gladiatorRoom)),
	assertz(location(gladiator, gladiatorRoom)),
	assertz(location(spartacus, gladiatorRoom)),
	assertz(location(commodus, gladiatorRoom)),
	assertz(location(flamma, gladiatorRoom)),
	assertz(location(winner, gladiatorRoom)),
	assertz(location(shoes, bridge)),
	assertz(location(gold, treasureChest)),
	assertz(location(sword, stairs)),
	assertz(location(food, emperorRoom)),
	assertz(location(shield, emperorRoom)),
	assertz(location(fed, animalCages)),
	
	retractall(locked(_)),
	assertz(locked(chest)),
	
    printLocation,
	dispPrompt,
    getInput.
	
% Prints out the players current location description
printLocation :-
    currentArea(Current),
    area(Current, _, Description),
	findall(Item, location(Item, Current), Item),
	write(Description),
	printItems(Item), nl.

% Changes the players current location, validity of change is checked in processInput
changeArea(NewArea) :-
    currentArea(Current),
    retract(currentArea(Current)),
    assertz(currentArea(NewArea)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

% Displays the player prompt so they can enter actions
dispPrompt :- prompt(_, '> ').

% Get input from the user
getInput :- readSentence(Input), getInput(Input).
getInput([quit]).
getInput(Input) :-
    processInput(Input), 
	printLocation,
    readSentence(Input1), 
	getInput(Input1).
	
% Reads a sentence from the prompt (unless game has ended)
readSentence(_) :-
	gameOver.	
readSentence(Input) :-
    readln(Input1, _, ".!?\n","_0123456789", lowercase),
    stripPunctuation(Input1, Input).

% Strips punctuation out of the user input
stripPunctuation([], []).
stripPunctuation([Word|Tail], [Word|Result]) :-
    \+(member(Word, ['.', ',', '?', '!'])),
    stripPunctuation(Tail, Result).
stripPunctuation([_|Tail], Result) :-
    stripPunctuation(Tail, Result).
	
% Recursively print the items in the current location.
printItems([]).
printItems([H | T]) :-
  item(H, Desc),
  printinPurple(Desc),
  printItems(T).
  
% Color for the item Text
printinPurple(Text) :-          
  print('\033[0;35m'), print(Text), print('\033[m').
  
% Color for the invenotry Text
printinCyan(Text) :-          
  print('\033[0;36m'), print(Text), print('\033[m').
  
% Color for the help Text
printinBlue(Text) :-
  print('\033[0;34m'), print(Text), print('\033[m').
  
% Color for the correct Text
printinGreen(Text) :-
  print('\033[0;32m'), print(Text), print('\033[m').
  
% Color for the error Text
printinRed(Text) :-
  print('\033[0;31m'), print(Text), print('\033[m').