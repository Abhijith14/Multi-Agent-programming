// Agent bob in project MAPC2018.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

//+!start  : name(agentA1)
	//<- .print("Im A1!!!!!!!").
	// print all percepts


+!start : true <- 
	.print("hello massim world.").
	// print all percepts

+step(X) : true <-
	.print("Received step percept.");
	.random_number(Number);
	.print("My current step is " ,X, Number).


+actionID(X) : .my_name(connectionA1) <- 
	.print("Determining my action for A1 ------- step " ,X);
	!move_random.

	
+actionID(X) : true <- 
	.print("Determining my action for step " ,X);
	move(w).

	