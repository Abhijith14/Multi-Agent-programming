/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

//curr_XY(X,Y).	
position(0,0).
occupied(false).
goal_reached(false).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("Received step percept").



+actionID(X) : true <- 
	.print("Determining my action");
	skip.


+task(Id,Deadline,Reward,ReqList) : true <- 
    .print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
    for (.member(req(X,Y,Block),ReqList)) {
		if(not(Y==1) & not(Y==2)){
        .print("Task ",Id," requires block of type ",Block," at coordinates (",X,",",Y,")");
		}
		else{
		.print("NO TASKS FOUND!!!");
		}
    }.


/*

+actionID(X) : occupied(true) & goal_reached(false) <- 
	.print("Determining my action");
	!collect_Blocks;
	.wait(1000);
	!attach_Blocks;
	.wait(1000);
	!move_random.


+!collect_Blocks : true <- 
	.print("Collecting blocks");
	request(s).


+!attach_Blocks : true <-
	.print("Attaching blocks");
	attach(s).


+actionID(X) : occupied(false) & goal_reached(false) <- 
	.print("Determining my action");
	!move_random. // to find dispensers



+actionID(X) : occupied(true) & goal_reached(true) <- 
	skip.



+lastAction(X) : true <-
	.print("The last action was ", X).


+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & occupied(false) & ((X > 0) | (X < 0) | (Y > 0) | (Y < 0)) <-
	.print("The dispenser is at ", X, Y);
	!move_to_cord(X,Y).
	

+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & occupied(false) & ((X == 0) | (Y = 0)) <-
	move(n);
	-occupied(false);
	+occupied(true).



+goal(X,Y) : occupied(true) & goal_reached(false) & ((X > 0) | (X < 0) | (Y > 0) | (Y < 0)) <-
	.print("The goal is at ", X, Y);
	!move_to_cord(X,Y).


+goal(X,Y) : occupied(true) & goal_reached(false) & ((X == 0) | (Y = 0)) <-
	-goal_reached(false);
	+goal_reached(true).
*/

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




//+!move_to_cord(X,Y) : (X==0) & (Y == 0) <- 
	//move(n);
	//-occupied(false);
	//+occupied(true).


