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

curr_Dir(Direction).

is_action_move(false).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("Received step percept").


+actionID(STEP) : is_edge(false, n) <- 
	.print("Determining my action");
	!move_random.


+actionID(STEP) : is_edge(true, n) <- 
	.print("Found the edge !!");
	skip.


+lastActionResult(Fail_code) : (Fail_code==failed_forbidden) & is_edge(false, n) & curr_Dir(n) <-
	.print("The last action failed because it was forbidden");
	?position(AgentX, AgentY);

	-is_edge(false, n);
	+is_edge(true, n);
	-edge_loc(EdgeX,EdgeY, n);
	+edge_loc(AgentX,AgentY, n).


//+lastActionResult(Fail_code) : (Fail_code==success) & is_edge(false, n) & curr_Dir(n) <-
	//.print("The last action Code is ", Fail_code);
	//!update_position(n).



+lastActionParams(Direction) : true <-

	?curr_Dir(CurrDirection);
	-curr_Dir(CurrDirection);
	+curr_Dir(Direction);

	.print("The direction is isnide the function : ", Direction).




+lastActionResult(Fail_code) : (Fail_code==success) <-
	.print("The last action Code is ", Fail_code);

	//?curr_Dir(Direction);
	lastActionParams(Direction);
	.print("The direction is : ", Direction);

	

//	if (curr_Dir(n) & is_edge(false, n)) {
//		.print("Got North");
		//!update_position(n);
//	} elif (curr_Dir(s) & is_edge(false, s)) {
//		//!update_position(s);
//		.print("Got South");
//	} elif (curr_Dir(e) & is_edge(false, e)) {
//		//!update_position(e);
//		.print("Got East");
//	} elif (curr_Dir(w) & is_edge(false, w)) {
//		//!update_position(w);
//		.print("Got West");
//	} else {
//		.print("I am not moving");
//	}.

    !update_position(n).


+!update_position(DIR) : true <-
	if  (DIR==n) {
	.print("updating position");
	?position(AgentX, AgentY);
	-position(AgentX, AgentY);
	+position(AgentX, AgentY-1);

	.print("My position is ", AgentX, AgentY);
	} else {
	.print("I am not moving north");
	}.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir) <-
	.print("moving to ", Dir);
	-curr_Dir(CurrDir);
	+curr_Dir(Dir);
	move(n).


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


