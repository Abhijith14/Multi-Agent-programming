/* Initial beliefs and rules */
//obstacle_location(X,Y).
temp_loc(0,-4).
//obstacle_location(0,0).


/* Initial goals */
!start.
/* Plans */
+!start : true <- 
    .print("hello massim world.").

/* +step(X) : true <-
    .print("Received step percept."). */

+actionID(Steps) : .my_name(connectionA2) & temp_loc(A,B) & (not(A==0)) <-
    .print("action function");	

    .print("NEW TEMP X LOC ",A);
    .print("NEW TEMP Y LOC ",B);

    //?obstacle_location(X,Y);
    !move_x_cord(A,B);
    .print("MOVED X").


+actionID(Steps) : .my_name(connectionA2) & temp_loc(NewA,NewB) & (NewA==0) <-
    .print("NEW TEMP LOC ",NewA, NewB); 
    !move_y_cord(NewA,NewB); // 0,-4
    .print("MOVED Y");
    
	?temp_loc(NewA2,NewB2);
	.print("NEW TEMP LOC ",NewA2, NewB2);
    .print("").




+obstacle(X,Y) : .my_name(connectionA2) <-
    .print("OBSTACLE POSITION ", X , Y);
    +obstacle_location(X,Y).


+!move_north(A,B) : true <-
	?obstacle_location(X,Y);
    .print("MOVINGING NORTH : X = ", X, " Y = ", Y, " A = ", A, " B = ", B);
    if ((X=0) & (Y=-1)) {
        .print("OBSTACLE DETECTED NORTH");
       // !move_x_cord(A,B,1,Y);
	   } 
    else {.print("ELSE MOVE NORTH");
         move(n);
        -temp_loc(A,B);
		+temp_loc(A,B+1);
		
		.print("NEW TEMP LOC after north : ",A, B);
		
	}.


+lastAction(Dir) : .my_name(connectionA2) <-
	.print("LAST ACTION ", Dir).

+lastActionParams(Params) : .my_name(connectionA2) <-
	.print("LAST ACTION PARAMS ", Params).

+lastActionResult(S) : .my_name(connectionA2) <-
	.print("LAST ACTION RESULT ", S).



+!move_south(A,B) : true <-
	?obstacle_location(X,Y);
    .print("MOVINGING SOUTH", Y);
    //?temp_y_loc(B);
    if ((X=0) & (Y=1)) {
        .print("OBSTACLE DETECTED SOUTH");
       // !move_x_cord(A,B);
	   } 
    else {move(s);
        -temp_loc(A,B);
		+temp_loc(A,B-1);}.

+!move_east(A,B) : true <-
	?obstacle_location(X,Y);
    .print("MOVINGING EAST", X);
    //?temp_x_loc(A);
    if ((X=1) & (Y=0)){
        .print("OBSTACLE DETECTED EAST");
       // !move_y_cord(A,B);
	   } 
    else {move(e);
        -temp_loc(A,B);
		+temp_loc(A-1,B);}.



+!move_west(A,B) : true <-
    ?obstacle_location(X,Y);
	.print("MOVINGING WEST : X = ", X, " Y = ", Y, " A = ", A, " B = ", B);
    if ((X=-1) & (Y=0)) {
        .print("OBSTACLE DETECTED WEST");
      //  !move_y_cord(A,B);
	  } 
    else {
		.print("Else of west triggered !!");
		move(w);
		-temp_loc(A,B);
		+temp_loc(A+1,B);

		.print("NEW TEMP LOC after west : ",A, B);

	
	}.
        //-temp_x_loc(A);
        //+temp_x_loc(A+1);}.


+!move_y_cord(A,B) : (B < 0) <- 
    .print("MOVING NORTH ONE STEP");
    !move_north(A,B).
	
+!move_y_cord(A,B) : (B > 0) <- 
    .print("MOVING SOUTH ONE STEP");
    !move_south(A,B).

+!move_y_cord(A,B) : (B = 0) <- 
    .print("NO NEED TO MOVE NORTH OR SOUTH").

+!move_x_cord(A,B) : (A > 0) <- 
    .print("MOVING EAST ONE STEP");
    !move_east(A,B).

+!move_x_cord(A,B) : (A < 0) <- 
    .print("MOVING WEST ONE STEP");
    !move_west(A,B).

+!move_x_cord(A,B) : (A = 0) <- 
    .print("NO NEED TO MOVE EAST OR WEST").
