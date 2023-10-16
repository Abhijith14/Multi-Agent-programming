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


/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("Starting agent").


//+step(STEPS) : position(X,Y) & .my_name(connectionA5)<-
//	.print("The agent is at position: ", X, ",", Y);
//	!move_to_cord(10,-5,X,Y);
//	!check_move_finish(10,-5,X,Y);
//	if (move_finish == true){
//		.print("OVER!!");
//	}
//	.

/*
+step(STEPS) : position(X,Y) & .my_name(connectionA5)<-
	.print("The agent is at position: ", X, ",", Y);
	!spider_search(X, Y)
	.
*/

+step(STEPS) : .my_name(connectionA5)  <-
	.print("Step: ", STEPS);
	//.print("The agent is at position: ", X, ",", Y);
	move(s)
	.


+position(X,Y) : .my_name(connectionA5) <- 
	.print("The agent is at position: ", X, ",", Y).


+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).


// -------------------	AGENT MOVEMENT		------------------- //



@spider_search[atomic]
+!spider_search(AgentX, AgentY) : true  <-
//	.print("Spider search");
	.wait(1000);
	if(spider_count(1)){ 
	//	.print("Spider count is 1");
		!move_to_cord(5,-5, AgentX, AgentY); 
		!check_move_finish(5,-5, AgentX, AgentY);
		if (move_finish(true)){
			-spider_count(1);
			+spider_count(2);
		}
	}
	elif(spider_count(2)){
		 !move_to_cord(5,5, AgentX, AgentY); 
		 !check_move_finish(5,5, AgentX, AgentY);
		 if (move_finish(true)){
		 	-spider_count(2);	
			+spider_count(3);
		}
	}
	elif(spider_count(3)){ 
		!move_to_cord(-5,5, AgentX, AgentY); 
		!check_move_finish(-5,5, AgentX, AgentY);
		if (move_finish(true)){
			-spider_count(3);
			+spider_count(4);
		}
	}
	elif(spider_count(4)){ 
		!move_to_cord(-5,-5, AgentX, AgentY); 
		!check_move_finish(-5,-5, AgentX, AgentY);
		if (move_finish(true)){
			-spider_count(4);
			+spider_count(1);
		}	
	}.





+!check_move_finish(X, Y, AgentX, AgentY): true<-
	if (X == AgentX & Y == AgentY){
		-move_finish(BOOL);
		-move_finish(false);
		+move_finish(true);
	}
	else{
		-move_finish(BOOL);
		-move_finish(true);
		+move_finish(false);
	}.


@movetocordinate1[atomic]
+!move_to_cord(X, Y, AgentX, AgentY) : true <-//position(AgentX, AgentY) & (not(X==AgentX)) <-
    .print("Moving to coordinates (", X, ",", Y, ")");

//	.print("Agent is at (", AgentX, ",", AgentY, ")");

	if (not(X==AgentX)){
	    !move_x_cord(X,Y,AgentX);
	}
	else{
		!move_y_cord(X,Y,AgentY);
	}
 //   .print("MOVED X").
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
   // !update_position(n).
	.

+!move_south(A,B) : true <-
	//.print("MOVE SOUTH");
    move(s);
   // !update_position(s).
	.


+!move_east(A,B) : true <-//obstacle_location(X,Y) <-
    //.print("MOVE EAST");
    move(e);
	//!update_position(e).
	.


+!move_west(A,B) : true <-
	//.print("MOVE WEST");
    move(w);
    //!update_position(w).

	.