/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("Starting agent").



+step(STEPS) : true <-
	.print("Received Step").


+actionID(STEPS) : true <- 
	.print("Step: ", STEPS).
