/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).


agentLoc(0,0).
distance(e, 6).
spider_num(6).
new_dir(s).

disp_reached(false).
disp_bypassed(false).

if_requested(false).
if_attached(false).

goal_search(false).
disp_search(false).


occupied(false, 0, 0).



/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("step ", X).



+task(Id,Deadline,Reward,ReqList) : true <- 
    +mytasks(Id, Deadline, Reward, ReqList).



+goal(X,Y) : goal_search(true) & occupied(false, ObjX, ObjY) <-
	.print("Goal is at ", X, Y);
	-+occupied(true, X, Y);
	+mygoalstates(X, Y).



+thing(X,Y,dispenser,ENTby) : goal_search(false) & occupied(false, ObjX, ObjY)  <-
	.print("The dispenser is at ", X, Y);
	-+occupied(true, X, Y).



+actionID(X) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(false)  <-
	!goto(ObjX, ObjY).


+actionID(S) : disp_reached(true)  & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) & goal_search(false) <-//& thing(X, Y, dispenser, ENTby)  <- 
	.print("Dispenser Reached !");
	if(BOOL == false){
			move(n);
			-+disp_bypassed(true);
	}
	else{

		if(BOOL2 == true & BOOL3 == false){
				attach(s);
				-+if_attached(true);
			}
			elif(BOOL3 == true){
				.print("WHERE IS THE FKING GOAL STATE !!!!!");

				-+goal_search(true);

				-+disp_reached(false);
				//-+disp_bypassed(false);

				-+if_requested(false);
				//-+if_attached(false);

				-+occupied(false, 0, 0);

				skip;

			}
			else{
				request(s);
				-+if_requested(true);
			}

	}.



+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(true)  <- 
	.print("Goal State recorded: ", ObjX, ObjY);
	!goto(ObjX,ObjY).


+actionID(S) : disp_reached(true) & goal_search(true)  <- 
	.print("GOAL REACHED !!! ");
	!check_task(b0, Id);
	.print("Task ID: ", Id);
	submit(Id).
	


+actionID(X) : occupied(false, ObjX, ObjY) <-
	skip.


+!goto(Gx,Gy) : occupied(BOOL, ObjX, ObjY) <-
	.print("Moving to ", Gx, Gy);

	if(Gx < 0){ 
		move(w); 
		-+occupied(BOOL, ObjX+1, ObjY);		
	}
	elif(Gx > 0){ 
		move(e); 
		-+occupied(BOOL, ObjX-1, ObjY); 
	}
	elif(Gy < 0){ 
		move(n); 
		-+occupied(BOOL, ObjX, ObjY+1); 		
	}
	elif(Gy > 0){ 
		move(s); 
		-+occupied(BOOL, ObjX, ObjY-1); 
	}
	else{ 
		.print("I am at the target", Gx, Gy); 
		-+disp_reached(true);
		skip;
	}.


+!check_task(Dispenser_id, Id) : true <- 
    .print("Checking task");

	if (mytasks(Id, Deadline, Reward, ReqList)) {

		//.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
		if (.member(req(X,Y,Dispenser_id),ReqList) & (.length(ReqList) == 1)){
			.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
			.print(ReqList);
			.print(.length(ReqList));

			for (.member(req(X,Y,Block),ReqList)) {
					.print("Task ",Id," requires block of type ",Block," at coordinates (",X,",",Y,")");
			}
		}
		else{
			.print("No task");
		}
	}
	else{
		.print("HAHAH No task");
	}.

