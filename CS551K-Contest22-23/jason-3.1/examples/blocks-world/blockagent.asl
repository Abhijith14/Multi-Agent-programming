/* Initial beliefs and rules */

clear(table).
clear(X) :- not(on(_,X)).
tower([X]) :- on(X,table).
tower([X,Y|T]) :- on(X,Y) & tower([Y|T]).

on(a,b).
on(b,t).
on(c,d).
on(d,e).
on(e,t).
on(f,t).

clear(t).
clear(X) :- not(on(_,X)).

above(X,Y) :- on(X,Y).
above(X,Y) :- on(X,Z) & above(Z,Y).


/* Initial goals */
!print.
!move(d,b).


/* Plans */
+!move(X,Y) : on(X, Y) <- !print.
+!move(X,Y) : clear(X) & clear(Y) & on(X,Z) 
	<- -on(X,Z); 
	   +on(X, Y); 
	   !print.

+!move(X,Y) : clear(X) & not clear(Y) & above(Z, Y) 
	<- !move(Z, t); 
	   !move(X,Y).

+!move(X,Y) : not clear(X) & clear(Y) & above(Z, X) 
	<- !move(Z, t); 
	   !move(X,Y).

+!move(X,Y) : not clear(X) & not clear(Y) & above(Z, X) & above(K, Y) 
	<- !move(Z, t); 
	   !move(K, t); 
	   !move(X,Y).


@print[atomic]
+!print <- for ( on(X,Y) ) {
				.print("Block ",X," is on top of block ",Y);
		   }
		   .print.


