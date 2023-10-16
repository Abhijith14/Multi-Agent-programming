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



+task(Id,Deadline,Reward,ReqList) : true <- 
    +mytasks(Id, Deadline, Reward, ReqList).



+goal(X,Y) : goal_search(true) <-
	.print("Goal is at ", X, Y);
	-+occupied(true, X, Y);
	+mygoalstates(X, Y).
	//skip.


+thing(X,Y,dispenser,ENTby) : goal_search(false) & occupied(false, ObjX, ObjY)  <-
	.print("The dispenser is at ", X, Y);
	-+occupied(true, X, Y);
	-+disp_search(true);
	-+mydispensers(X, Y, ENTby).
	//!goto(X,Y).



+actionID(S) : agentLoc(X,Y) & distance(Dir, Dist) & occupied(false, ObjX, ObjY) <- 
	.print("Step: ", S);
	!spider_search;
	!updatePos(Dir);
	.print("Agent Loc at", X, " ---- ", Y).


+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(false)  <- 
	.print("Dispenser recorded: ", ObjX, ObjY);
	!goto(ObjX,ObjY).



//+actionID(S) : disp_reached(true) & thing(X, Y, dispenser, ENTby) & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) & goal_search(false) <- 
+actionID(S) : disp_reached(true) & mydispensers(X, Y, ENTby) & disp_bypassed(BOOL) & if_requested(BOOL2) & if_attached(BOOL3) & goal_search(false) <- 
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
		.print("YOU ARE HERE !!!!!");

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
        -+occupied(true, X, Y);
	}.
	
	



+actionID(S) : occupied(true, ObjX, ObjY) & disp_reached(false) & goal_search(true)  <- 
	.print("Goal State recorded: ", ObjX, ObjY);
	skip.
	//!goto(ObjX,ObjY).



//+actionID(S) : true <- 
	//skip.


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




+!goto(Gx,Gy) : occupied(BOOL, ObjX, ObjY) <-
	.print("Moving to ", Gx, Gy);

	if(Gx < 0){ 
		move(w); 
		-+occupied(BOOL, ObjX+1, ObjY); 
		-+mydispensers(X+1, Y, ENTby);
	}
	elif(Gx > 0){ 
		move(e); 
		-+occupied(BOOL, ObjX-1, ObjY); 
		-+mydispensers(X-1, Y, ENTby);	
	}
	elif(Gy < 0){ 
		move(n); 
		-+occupied(BOOL, ObjX, ObjY+1); 
		-+mydispensers(X, Y+1, ENTby);	
	}
	elif(Gy > 0){ 
		move(s); 
		-+occupied(BOOL, ObjX, ObjY-1); 
		-+mydispensers(X, Y-1, ENTby);
	}
	else{ 
		.print("I am at the target", Gx, Gy); 
		-+disp_reached(true);
		skip;
	}.
	

