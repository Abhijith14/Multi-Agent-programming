/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

//curr_XY(X,Y).	
position(0,0).
occupied(false).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("Received step percept").
	

+actionID(X) : occupied(true) <- 
	.print("Determining my action");
	skip.
	

+actionID(X) : occupied(false) <- 
	.print("Determining my action");
	//.wait(1000);
	!move_random.


+lastAction(X) : true <-
	.print("The last action was ", X).


+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & occupied(false) <-
	.print("The dispenser is at ", X, Y);
	!move_to_cord(X,Y).


+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).


+!move_to_cord(X,Y) : (X<0) <- 
	.print("moving x<0 haha ", X, Y);
	move(w).


+!move_to_cord(X,Y) : (X>0) <- 
	.print("moving x>0 haha ", X, Y);
	move(e).


+!move_to_cord(X,Y) : (X==0) & (Y < 0) <- 
	.print("moving y<0 haha ", X, Y);
	move(n).


+!move_to_cord(X,Y) : (X==0) & (Y > 0) <- 
	.print("moving y<0 haha ", X, Y);
	move(s).


+!move_to_cord(X,Y) : (X==0) & (Y == 0) <- 
	move(n);
	-occupied(false);
	+occupied(true).





