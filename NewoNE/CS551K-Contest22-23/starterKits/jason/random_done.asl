/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

//curr_XY(X,Y).	
position(0,0).
occupied(false).
goal_reached(false).

mytasks(Id, Deadline, Reward, ReqList).

currTask(Id).


/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("Received step percept");
	!check_task(b0, Id).



+task(Id,Deadline,Reward,ReqList) : true <- 
	+mytasks(Id, Deadline, Reward, ReqList).



+lastActionResult(X) : ((X==failed_forbidden) | (X==failed_target) | (X==failed) | (X==failed_target) | (X==failed_blocked) | (X==failed_target)) <-
	.print("The last action result was ", X);
	!move_random.


@checkingtask[atomic]
+!check_task(Dispenser_id, Id) : true <- 
	.print("Checking task");

	?tasks(Id, Deadline, Reward, ReqList);
	.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward).





	//if(mytasks(Id, Deadline, Reward, ReqList) & .member(req(X,Y,Dispenser_id),ReqList)){
		//.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
		//.print(ReqList);
	//	for (.member(req(X,Y,Block),ReqList)) {
	//			.print("Task ",Id," requires block of type ",Block," at coordinates (",X,",",Y,")");
	//	}
	//}
//	else{
//		.print("No task");
	//}.


//+actionID(X) : occupied(true) & goal_reached(false) <- 
//	.print("Determining my action");
//	!collect_Blocks;
//	.wait(1000);
//	!attach_Blocks;
//	.wait(1000);
//	!move_random.


+!collect_Blocks : true <- 
	.print("Collecting blocks");
	request(s).


+!attach_Blocks : true <-
	.print("Attaching blocks");
	attach(s).


+!submit_Task : true <-
	.print("Submitting task");
	?currTask(Id);
	submit(Id).


//+actionID(X) : occupied(false) & goal_reached(false) <- 
//	.print("Determining my action");
//	!move_random. // to find dispensers



//+actionID(X) : occupied(true) & goal_reached(true) <- 
//	.print("Determining my action");
//	!submit_Task;
//	!move_random.



+lastAction(X) : true <-
	.print("The last action was ", X).


+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & occupied(false) & ((X > 0) | (X < 0) | (Y > 0) | (Y < 0)) <-
	.print("The dispenser is at ", X, Y);
	!move_to_cord(X,Y).
	

+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & occupied(false) & ((X == 0) | (Y = 0)) <-
	move(n);
	-occupied(false);
	+occupied(true);
	!check_task(ENTby, Id);
	.print("I have perceived a new task ",Id);
	?currTask(OtherId);
	-currTask(OtherId);
	+currTask(Id).



+goal(X,Y) : occupied(true) & goal_reached(false) & ((X > 0) | (X < 0) | (Y > 0) | (Y < 0)) <-
	.print("The goal is at ", X, Y);
	!move_to_cord(X,Y).


+goal(X,Y) : occupied(true) & goal_reached(false) & ((X == 0) | (Y = 0)) <-
	-goal_reached(false);
	+goal_reached(true).


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





