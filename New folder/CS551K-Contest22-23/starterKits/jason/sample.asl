/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

//curr_XY(X,Y).	
position(0,0).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").


+step(X) : true <-
	.print("Received step percept").
	
+actionID(X) : .my_name(connectionA1) <- 
	//.wait(1000);
	//rotate(ccw).
	//attach(n).
	//skip.
	!move_random.
	//submit(task658).


+actionID(X) : .my_name(connectionA4) <- 
	!move_random.


+actionID(X) : true <- 
	.print("Determining my action");
	//!move_random.
	!move_to_cord(20,22);
	skip.
	//!move_random.


//+score(X) : true <-
	//.print("The current team score is: ", X).


+lastAction(X) : true <-
	.print("The last action was ", X).


//+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & X == -1 <-
//  	request(w);
	//attach(w);
	//!move_random.

//+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & X == 1 <-
  //	request(e);
	//attach(e);
	//!move_random.

//+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & Y == 1 <-
  //	request(s);
//	attach(s);
	//!move_random.

//+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser & Y == -1 <-
 // 	request(n);
//	attach(n);
	//!move_random.

//+thing(X,Y,ENTtype,ENTby) : ENTtype == dispenser <-
	///.print("The dispenser is at ", X, Y).
	// count the number of dispensers
	//!find_dispenser.



//+thing(X,Y,ENTtype,ENTby) : true <-
//	skip.
	//.print("The Thing found is ", ENTtype, " by ", ENTby, " at ", X, Y).


//+task(Id,Deadline,Reward,ReqList) : true <- 
	//.print("I have perceived a new task ",Id," with deadline of ",Deadline," steps and a reward of ",Reward);
  	//for (.member(req(X,Y,Block),ReqList)) {
   //		.print("Task ",Id," requires block of type ",Block," at coordinates (",X,",",Y,")");
  	//}.


//+attached(X,Y) : true <- 
	//.print("I have attached a block of type at coordinates (",X,",",Y,")").


+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).


//+!move_to_cord(X,Y) : true <- 
	//?position(X2,Y2);
	//-position(X2,Y2);
	//+position((X2-1),Y2);


+!move_to_cord(X,Y) : (X<0) <- 
	.print("I am already at the target location", X, Y).


+!move_to_cord(X,Y) : (X>0) <- 
	.print("I am already at the tarsdgfsdgsdgsdfgsget location", X, Y).

//+!find_dispenser : true <-
	