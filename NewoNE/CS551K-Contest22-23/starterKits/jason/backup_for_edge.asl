/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

occupied(false).

edge_loc(0,0, n).
edge_loc(0,0, e).
edge_loc(0,0, w).
edge_loc(0,0, s).


is_edge(false, n).
is_edge(false, e).
is_edge(false, w).
is_edge(false, s).


position(0,0).

is_action_move(false).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : is_edge(false, n) <-
	//.print("Received step percept");
	move(n).




+step(X) : is_edge(true, n) <-
	//.print("Foound North Edge...");
	skip.

/*
+step(X) : is_edge(false, n) & lastAction(move) <-
	.print("Foound Action Move...").


+actionID(STEP) : true <- 
	.print("Determining my action").
	//move(n).

*/

@lastaction1[atomic]
+lastAction(Action) : (Action == move) & is_edge(false, n) & lastActionResult(FailCode) & (FailCode == success) <-
	.print("Moving North");
	!update_position(n).


@lastaction2[atomic]
+lastActionResult(Fail_code) : (Fail_code==success) & is_edge(false, n) & lastAction(Action) & (Action == move) <-
	.print("The last action Code is ", Fail_code);
	!update_position(n).






//+lastActionResult(Fail_code) : (Fail_code==success) & is_edgeN(true) & position(Ax, Ay) & edgeN_loc(Ax, Ay) <-
//	.print("At the NORTH EDGE !!!").
	//!update_position(n).

@updateposition[atomic]
+!update_position(DIR) : (DIR==n) <-
	.print("updating position");
	?position(AgentX, AgentY);
	-position(AgentX, AgentY);
	+position(AgentX, AgentY-1);

	.print("My position is ", AgentX, AgentY-1).


+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).


+!move_to_cord(X,Y) : (X<0) <- 
	.print("moving 1 step west ", X, Y);
	.wait(1000);
	move(w).


+!move_to_cord(X,Y) : (X>0) <- 
	.print("moving 1 step east ", X, Y);
	.wait(1000);
	move(e).


+!move_to_cord(X,Y) : (X==0) & (Y < 0) <- 
	.print("moving 1 step west ", X, Y);
	.wait(1000);
	move(n).


+!move_to_cord(X,Y) : (X==0) & (Y > 0) <- 
	.print("moving y<0 haha ", X, Y);
	.wait(1000);
	move(s).


+!move_to_cord(X,Y) : (X==0) & (Y == 0) <- 
	move(n);
	-occupied(false);
	+occupied(true).


