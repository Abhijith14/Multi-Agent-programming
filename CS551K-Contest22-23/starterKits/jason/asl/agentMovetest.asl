/* Initial beliefs and rules */

/* Initial position */
+position(0, 0).

/* Initial goals */

!start.

/* MOVE action*/
+!move(s) <- move(s).
+!move(n) <- move(n).
+!move(e) <- move(e).
+!move(w) <- move(w).

/* update memory about position */
+!update_position(s): position(X,Y) <- -position(X,Y); +position(X,Y+1).
+!update_position(n): position(X,Y) <- -position(X,Y); +position(X,Y-1).
+!update_position(e): position(X,Y) <- -position(X,Y); +position(X+1,Y).
+!update_position(w): position(X,Y) <- -position(X,Y); +position(X-1,Y).

/* Plans */

+!start : true <- 
	.print("hello massim world.").
	!move(s).
	!update_position(s).

