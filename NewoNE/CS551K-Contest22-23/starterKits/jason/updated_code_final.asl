/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

occupied(false, 0, 0).

edge_loc(0,0, n).
edge_loc(0,0, e).
edge_loc(0,0, w).
edge_loc(0,0, s).


is_edge(false, n).
is_edge(false, e).
is_edge(false, w).
is_edge(false, s).

spider_count(1).
move_finish(false).


//is_move(false).


position(0,0).

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("Starting agent").


// goal(-3,-2)
// thing(0,0,entity,"A")
// thing(-2,0,dispenser,b1)
// obstacle(-4,0)



+goal(X, Y) : true <-
	//.print("Goal is at (", X, ",", Y, ")");
	+goal_location(X, Y).


+thing(X,Y,dispenser, DispID) : true <-
	//.print("Dispenser is at (", X, ",", Y, ")");
	+dispenser_location(X, Y, DispID);
	//?occupied(false, X, Y);
	-occupied(false, X2, Y2);
	+occupied(true, X, Y).

+obstacle(X,Y) : true <-
//	.print("Obstacle is at (", X, ",", Y, ")");
	+obstacle_location(X, Y).


+step(STEPS) : occupied(false, X, Y) <-
	.print("Startingsdfsdf Spider");
	!spider_search.


+step(STEPS) : occupied(true, X, Y) & goal_reached(false) <-
	!move_to_cord(X, Y);
	!check_move_finish(X, Y);
	if (move_finish(true)){
		!force_misplaced_agents;
		//!collect_Blocks;
		//!attach_Blocks;
		//!spider_search;
		//!submit_Task;
		//-goal_reached(true);
	}.
//	else{
//		!update_position(STEPS);
//		!step(STEPS);
//	}.





//+step(X) : true <-
//	.print("Received step percept");
//	skip.	


// -------------------	Task		------------------- //


+!force_misplaced_agents : position(AgentX, AgentY) <-
	?thing(X,Y,dispenser, DispID);
	//.print("A Dispenser is at (", X, ",", Y, ")").
.


+!collect_Blocks : true <- 
	//.print("Collecting blocks");
	request(s).


+!attach_Blocks : true <-
//.print("Attaching blocks");
	attach(s).


+!submit_Task : true <-
//	.print("Submitting task");
	?currTask(Id);
	submit(Id).




// -------------------	Spider Search		------------------- //



+!check_move_finish(X, Y): position(AgentX, AgentY) <-
	if (X == AgentX & Y == AgentY){
		//.print("I have reached my destination");
		//?move_finish(false);
		-move_finish(false);
		+move_finish(true);
	}
	else{
		//.print("I have not reached my destination");
		//?move_finish(true);
		-move_finish(true);
		+move_finish(false);
	}.



@spider_search[atomic]
+!spider_search : true  <-
//	.print("Spider search");
	?position(AgentX, AgentY);
	.wait(1000);
	if(spider_count(1)){ 
	//	.print("Spider count is 1");
		!move_to_cord(5,-5); 
		!check_move_finish(5,-5);
		if (move_finish(true)){
			-spider_count(1);
			+spider_count(2);
		}
	}
	elif(spider_count(2)){
		 !move_to_cord(5,5); 
		 !check_move_finish(5,5);
		 if (move_finish(true)){
		 	-spider_count(2);	
			+spider_count(3);
		}
	}
	elif(spider_count(3)){ 
		!move_to_cord(-5,5); 
		!check_move_finish(-5,5);
		if (move_finish(true)){
			-spider_count(3);
			+spider_count(4);
		}
	}
	elif(spider_count(4)){ 
		!move_to_cord(-5,-5); 
		!check_move_finish(-5,-5);
		if (move_finish(true)){
			-spider_count(4);
			+spider_count(1);
		}	
	}.



@updateposition[atomic]
+!update_position(DIR) : true <-
//	.print("updating position");
	?position(AgentX, AgentY);
	-position(AgentX, AgentY);
	if (DIR == n){
		+position(AgentX, AgentY-1);
	}
	elif (DIR == s){
		+position(AgentX, AgentY+1);
	}
	elif (DIR == e){
		+position(AgentX+1, AgentY);
	}
	elif (DIR == w){
		+position(AgentX-1, AgentY);
	}


	?position(AgentX1, AgentY1);
//	.print("My position is ", AgentX1, AgentY1).
.

// -------------------	AGENT MOVEMENT		------------------- //


@movetocordinate1[atomic]
+!move_to_cord(X, Y) : position(AgentX, AgentY) & (not(X==AgentX)) <-
   // .print("Moving to coordinates (", X, ",", Y, ")");

//	.print("Agent is at (", AgentX, ",", AgentY, ")");

    !move_x_cord(X,Y,AgentX);
 //   .print("MOVED X").
.

@movetocordinate2[atomic]
+!move_to_cord(X, Y) : position(AgentX, AgentY) & (X==AgentX) <-

//	.print("Agent is at (", AgentX, ",", AgentY, ")");

	!move_y_cord(X,Y,AgentY);
//	.print("MOVED Y").
.

// moving to the x coordinate
@moveX1[atomic]
+!move_x_cord(A,B, AgentX) : (A > AgentX) <- 
    //.print("MOVING EAST ONE STEP");
    !move_east(A,B).

@moveX2[atomic]
+!move_x_cord(A,B,AgentX) : (A < AgentX) <- 
    //.print("MOVING WEST ONE STEP");
    !move_west(A,B).

@moveX3[atomic]
+!move_x_cord(A,B) : (A == AgentX) <- 
    .print("NO NEED TO MOVE EAST OR WEST").


// moving to the y coordinate
@moveY1[atomic]
+!move_y_cord(A,B, AgentY) : (B < AgentY) <- 
    //.print("MOVING NORTH ONE STEP");
    !move_north(A,B).


@moveY2[atomic]
+!move_y_cord(A,B, AgentY) : (B > AgentY) <- 
    //.print("MOVING SOUTH ONE STEP");
    !move_south(A,B).

@moveY3[atomic]
+!move_y_cord(A,B, AgentY) : (B == AgentY) <- 
    .print("NO NEED TO MOVE NORTH OR SOUTH").


+obstacle(X,Y) : true <-
    //.print("OBSTACLE POSITION ", X , Y);
    +obstacle_location(X,Y).


+!move_north(A,B) : true <- // obstacle_location(X,Y) <-
  //  .print("MOVE NORTH");
    move(n);
	-is_move(Cond, Dir);
	+is_move(true, n);
   // !update_position(n).
	.

+!move_south(A,B) : true <-
	//.print("MOVE SOUTH");
    move(s);
	-is_move(Cond, Dir);
	+is_move(true, s);
   // !update_position(s).
	.


+!move_east(A,B) : true <-//obstacle_location(X,Y) <-
    //.print("MOVE EAST");
    move(e);
	-is_move(Cond, Dir);
	+is_move(true, e);
	//!update_position(e).
	.


+!move_west(A,B) : true <-
	//.print("MOVE WEST");
    move(w);
	-is_move(Cond, Dir);
	+is_move(true, w);
    //!update_position(w).

	.


// -------------------	Update Position		------------------- //

//+lastAction(A) : true <-
//	.print("LAST ACTION WAS ", A);
//	?lastActionResult(result);
//	.print("LAST ACTION RESULT WAS ", result).

//+lastActionResult(Result) : (Result == failed_forbidden) <-
//	.print("LAST ACTION FAILED FORBIDDEN");
	//!move_random.

+lastActionResult(Result) : (Result == success) <-
	//.print("LAST ACTION SUCCEEDED");
	if(is_move(true, Dir)){
		!update_position(Dir);
	}.



