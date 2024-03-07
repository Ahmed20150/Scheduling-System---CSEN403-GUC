ta_slot_assignment(TAs,RemTAs,Name):-
	slothelper1(TAs,[],RemTAs,Name).

slothelper1([],Acc,Acc,_).

slothelper1([ta(Name,N)|T],Acc,Res,Name):-
	N>0,
	N1 is N-1,
	append(Acc,[ta(Name,N1)],Newacc),
	slothelper1(T,Newacc,Res,Name).
	
slothelper1([ta(Name,0)|T],Acc,Res,Name):-
	append(Acc,[ta(Name,0)],Newacc),
	slothelper1(T,Newacc,Res,Name).

slothelper1([ta(X,N)|T],Acc,Res,Name):-
	Name\=X,
	append(Acc,[ta(X,N)],Newacc),
	slothelper1(T,Newacc,Res,Name).


%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

slot_assignment(LabsNum,TAs,RemTAs,Assignment):-
	slothelper(LabsNum,TAs,[],RemTAs,[],Assignment).
	
slothelper(0,TAs,Racc,RemTAs,Acc,Acc):-
	append(Racc,TAs,RemTAs).
			
slothelper(LabsNum,[ta(X,N)|T],Racc,RemTAs,Acc,Res):-
	LabsNum>0,
	N>0,
	append(Acc,[X],Newacc),
	Newlabs is LabsNum-1,
	ta_slot_assignment([ta(X,N)|T],[H|_],X),
	append(Racc,[H],Newracc),
	slothelper(Newlabs,T,Newracc,RemTAs,Newacc,Res).

slothelper(LabsNum,[ta(X,0)|T],Racc,RemTAs,Acc,Res):-
		LabsNum>0,
	append(Racc,[ta(X,0)],Newracc),
	slothelper(LabsNum,T,Newracc,RemTAs,Acc,Res).	

slothelper(LabsNum,[H|T],Racc,RemTAs,Acc,Res):-
	LabsNum>0,
	append(Racc,[H],Newracc),
	slothelper(LabsNum,T,Newracc,RemTAs,Acc,Res).	

%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

count(_,[],1).
count(X,[X|T],S):-
	count(X,T,S1),
	S is S1+1.
	
count(X,[H|T],S):-
	X\=H,
	count(X,T,S).

max_slots_per_day(DaySched,Max):-
	flatten(DaySched,L),maxhelper(L,Max).
	
maxhelper([],Max).

maxhelper([H|T],Max):-	
	count(H,T,S),
	S=<Max,
	maxhelper(T,Max).
	
%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

day_schedule(DaySlots,TAs,RemTAs,Assignment):-
	dayhelper(DaySlots,TAs,RemTAs,[],Assignment).

dayhelper([],RemTAs,RemTAs,Acc,Acc).

dayhelper([H|T],TAs,RemTAs,Acc,Assignment):-
	slot_assignment(H,TAs,NewRem,Newassign),
	append(Acc,[Newassign],Newacc),
	dayhelper(T,NewRem,RemTAs,Newacc,Assignment).
	
%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

week_schedule(WeekSlots,TAs,DayMax,WeekSched):-
	weekhelper(WeekSlots,TAs,DayMax,[],WeekSched).
	
weekhelper([],_,_,Acc,Acc).

weekhelper([H|T],TAs,DayMax,Acc,Res):-
	day_schedule(H,TAs,RemTAs,Assign),
	max_slots_per_day(Assign,DayMax),
	append(Acc,[Assign],Newacc),
	weekhelper(T,RemTAs,DayMax,Newacc,Res).

	
	
	
	




	