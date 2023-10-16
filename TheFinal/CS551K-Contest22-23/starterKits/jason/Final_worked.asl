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


occupied(false, 0, 0, ELEMENT).


/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

/*
+step(X) : true <-
	.print("step ", X).

*/


+task(Id,Deadline,Reward,ReqList) : true <- 
    +mytasks(Id, Deadline, Reward, ReqList).



+step(X) : occupied(true, ObjX, ObjY, ELE) & disp_reached(false) & goal_search(false) <-
	!goto(ObjX, ObjY).


+step(S) : occupied(false, ObjX, ObjY, ELE) & distance(Dir, Dist) & goal_search(false) <-
	if (thing(X,Y,dispenser,ENTby)){
		-+occupied(true, X, Y, ENTby);
		skip;
	}
	else{
		!spider_search;
		!updatePos(Dir);
	}.


+step(S) : occupied(false, ObjX, ObjY, ELE) & distance(Dir, Dist) & goal_search(true) <-
	if (goal(X,Y)){
		-+occupied(true, X, Y, ELE);
		skip;
	}
	else{
		!spider_search;
		!updatePos(Dir);
	}.



+step(S) : disp_reached(true)  & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) & goal_search(false) <- 
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
				-+disp_bypassed(false);

				-+if_requested(false);
				-+if_attached(false);

				-+occupied(false, 0, 0, ELE);

				skip;

			}
			else{
				request(s);
				-+if_requested(true);
			}

	}.


+step(S) : occupied(true, ObjX, ObjY, ELE) & disp_reached(false) & goal_search(true)  <- 
	.print("Goal State recorded: ", ObjX, ObjY);
	!goto(ObjX,ObjY).



+step(S) : disp_reached(true) & goal_search(true) & occupied(true, ObjX, ObjY, ELE)  <- 


	if(lastAction(submit) & lastActionResult(success)){

		-+disp_reached(false);
		-+goal_search(false);
		-+occupied(false, 0, 0, ELE);

		skip;
	}
	else{
		.print("GOAL REACHED !!! ");
		!check_task(ELE, Id);
		.print("Task ID: ", Id);

		submit(Id);
	}.


+!spider_search : distance(Dir, Dist) & new_dir(Dir2) & occupied(false, ObjX, ObjY, ELE) & spider_num(SpiderVar) <- 
	.print("Spider Search");

	if(Dist == 0){ 
		.print("Distance is 0");
		if (Dir == e){ 
			-+distance(s, SpiderVar); 
			-+new_dir(w);
		} 
		elif (Dir == s){ 
			-+distance(w, SpiderVar); 
			-+new_dir(n);
		} 
		elif (Dir == w){ 
			-+distance(n, SpiderVar); 
			-+new_dir(e);
		} 
		elif (Dir == n){ 
			-+distance(e, SpiderVar); 
			-+new_dir(s);
		}

		move(Dir2);
		-+distance(Dir2, SpiderVar-1); 
	}
	else{ 
		move(Dir); 
		-+distance(Dir, Dist-1); 
	}.



+!spider_search : occupied(true, ObjX, ObjY, ELE) <-
	.print("Spider Search COMPLETE !!");
	skip.



+!goto(Gx,Gy) : occupied(BOOL, ObjX, ObjY, ELE) <-
	.print("Moving to ", Gx, Gy);

	if(Gx < 0){ 
		move(w); 
		-+occupied(BOOL, ObjX+1, ObjY, ELE);		
	}
	elif(Gx > 0){ 
		move(e); 
		-+occupied(BOOL, ObjX-1, ObjY, ELE); 
	}
	elif(Gy < 0){ 
		move(n); 
		-+occupied(BOOL, ObjX, ObjY+1, ELE); 		
	}
	elif(Gy > 0){ 
		move(s); 
		-+occupied(BOOL, ObjX, ObjY-1, ELE); 
	}
	else{ 
		.print("I am at the target", Gx, Gy); 
		-+disp_reached(true);
		skip;
	}.



+!updatePos(V): agentLoc(X,Y) <-
	if(V==n){
		-+agentLoc(X,Y-1);
	}
	elif(V==s){
		-+agentLoc(X,Y+1);
	}
	elif(V==e){
		-+agentLoc(X+1,Y);
	}
	elif(V==w){
		-+agentLoc(X-1,Y);
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


			/*-+disp_reached(false);
			-+disp_bypassed(false);
			-+if_requested(false);
			-+if_attached(false);
			-+occupied(false, 0, 0, ELE);
			-+goal_search(false); */



		}
		else{
			.print("No task");
		}
	}
	else{
		.print("Waiting for a new task");
	}.



+lastAction(move): lastActionResult(failed_forbidden) & lastActionParams(P) & agentLoc(X,Y) & distance(Dir, Dist) & spider_num(SpiderVar) & occupied(false, ObjX, ObjY, ELE) <-
	.print("Move Failed");
	.member(V,P);
	if(V==n){
		-+agentLoc(X,Y+1);
		-+distance(e, SpiderVar);
	}
	elif(V==s){
		-+agentLoc(X,Y-1);
		-+distance(w, SpiderVar);
	}
	elif(V==e){
		-+agentLoc(X-1,Y);
		-+distance(s, SpiderVar);
	}
	elif(V==w){
		-+agentLoc(X+1,Y);
		-+distance(n, SpiderVar);
	}
	.


