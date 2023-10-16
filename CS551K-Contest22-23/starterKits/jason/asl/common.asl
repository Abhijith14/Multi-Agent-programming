/* Beliefs */

belief_base

/* Initial goals */

!start.

/* Plans */

+!start : true <-
.print("hello massim world.").

+step(X) : true <-
.print("Received step percept.").

+actionID(X) : true <-
.print("Determining my action for step " ,X).

