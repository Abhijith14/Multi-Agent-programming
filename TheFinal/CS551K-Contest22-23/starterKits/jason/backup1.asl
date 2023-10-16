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



//mydispensers(X, Y, ENTby) :- thing(X, Y, dispenser, ENTby).
//mygoalstates(X, Y) :- goal(X,Y).


/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

+step(X) : true <-
	.print("Received step percept.").
	
+actionID(S) : agentLoc(X,Y) & distance(Dir, Dist) & occupied(false, ObjX, ObjY) <- 
	.print("Step: ", S);
	!spider_search;
	!updatePos(Dir);
	.print("Agent Loc at", X, " ---- ", Y).


+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(false)  <- 
	.print("Dispenser recorded: ", ObjX, ObjY);
	!goto(ObjX,ObjY).
	//skip.
//	!goto(ObjX,ObjY).



+actionID(S) : disp_reached(true) & thing(X, Y, dispenser, ENTby) & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) & goal_search(false) <- 
//+actionID(S) : disp_reached(true) & mydispensers(X, Y, ENTby) & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) <- 
	.print("Dispenser Reached !");
	.print("Dispenser is at ", X, Y);
	.print("Dispenser Type is ", ENTby);

	if(X == 0 & Y == 0){
		.print("Dispenser Reached FINALYYYY!");
		if(BOOL == false){
			move(n);
			-+disp_bypassed(true);
		}
	}
	elif (BOOL == true){

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
	}

	else{
		.print("Dispenser is away !");
		!goto(X,Y);
        //update obstacle x and y
		//skip;
	}.
	//else{
//		-+disp_reached(false);
	//	!goto(X,Y);
//	}.



+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(true)  <- 
	.print("Goal State recorded: ", ObjX, ObjY);
	!goto(ObjX,ObjY).


+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(true) & goal_search(true)  <- 
	.print("GOAL REACHED !!! ", ObjX, ObjY);
	!check_task(b0);
    //.print("I have perceived a new task ",Id);
	//!goto(ObjX,ObjY).
	skip.
	


+actionID(S) : disp_reached(B1) & thing(X, Y, dispenser, ENTby) & disp_bypassed(B2) & if_requested(B3) & if_attached(B4) & goal_search(false) <- 
	
	skip.



+actionID(S) : true <- 
	
	skip.




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


/*
+!check_task(Dispenser_id) : task(Id, Deadline, Reward, ReqList) <- 
    .print("Checking task");
    //.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
	if (.member(req(X,Y,Dispenser_id),ReqList)){
		.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
		.print(ReqList);
		for (.member(req(X,Y,Block),ReqList)) {
				.print("Task ",Id," requires block of type ",Block," at coordinates (",X,",",Y,")");
		}
	}
	else{
		.print("No task");
	}.
*/


+task(Id,Deadline,Reward,ReqList) : true <- 
    +mytasks(Id, Deadline, Reward, ReqList).



+goal(X,Y) : goal_search(true) <-
	.print("Goal is at ", X, Y);
	-+occupied(true, X, Y);
	+mygoalstates(X, Y).
	//skip.


+thing(X,Y,dispenser,ENTby) : goal_search(false) <-//& occupied(false, ObjX, ObjY)  <-
	.print("The dispenser is at ", X, Y);
	-+occupied(true, X, Y);
	-+disp_search(true);
	+mydispensers(X, Y, ENTby).
	//!goto(X,Y).
	


+!goto(Gx,Gy) : occupied(BOOL, ObjX, ObjY) <-
	.print("Moving to ", Gx, Gy);

	if(Gx < 0){ move(w); }//-+occupied(BOOL, ObjX+1, ObjY); }
	elif(Gx > 0){ move(e);}// -+occupied(BOOL, ObjX-1, ObjY); }
	elif(Gy < 0){ move(n);}// -+occupied(BOOL, ObjX, ObjY+1); }
	elif(Gy > 0){ move(s);}// -+occupied(BOOL, ObjX, ObjY-1); }
	else{ 
		.print("I am at the target", Gx, Gy); 
		-+disp_reached(true);
		skip;
	}.
	


+!spider_search : distance(Dir, Dist) & new_dir(Dir2) & occupied(false, ObjX, ObjY) & spider_num(SpiderVar) <- 
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


+!spider_search : occupied(true, ObjX, ObjY) <-
	.print("Spider Search COMPLETE !!");
	skip.




+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).

	
+lastAction(move): lastActionResult(failed_forbidden) & lastActionParams(P) & agentLoc(X,Y) & distance(Dir, Dist) & spider_num(SpiderVar) & occupied(false, ObjX, ObjY) <-
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
