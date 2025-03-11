

%initiating program run :
init_prog(FileName):-
    writeln("Code:"),
    printFile(FileName),
    writeln(" "),
    writeln("Output Run:"),
    getins(FileName,Lines),
    initRegs(32,Regs),
    run_prog(Lines,Regs,1).

% getins returns a list of strings that stores each line from file in
% the same order,
getins(FileName,Lines):-
    open(FileName,read,Stream),
    read_all_lines(Stream,Lines),
    close(Stream).

%initReg returns a list of 32 elements all set to 0 initially
initRegs(0,[]).
initRegs(Count,[0|Rest]):-
    Count > 0,
    C1 is Count - 1,
    initRegs(C1,Rest).


%main:
run_prog(Lines,Regs,Pc):-
    getIth(Pc,Lines,Line),
    exec_command(Line,Regs,Pc,Rn,Pcn),
    run_prog(Lines,Rn,Pcn).

run_prog(_,_,0):-!. %the program stops if pc is 0 (pc is set to zero by halt instruction)

%exec_command() : will parse the line into instruction and prameters
%for example inst:'jumpe'  and params:'r*,r*,8'
exec_command(Line,Regs,Pc,Rn,Pcn):-
    split_string(Line," ","",[Inst,Params]),

    %to execute the instruction:
    exec_inst(Inst, Params, Regs, Pc, Rn ,Pcn).

% exec_inst will identify which instruction we got and call the
% appropiate predicate:
exec_inst("put" ,Params, Regs, Pc, Rn, Pcn):-
    put(Params, Regs, Pc, Rn, Pcn).

exec_inst("add" ,Params, Regs, Pc, Rn, Pcn):-
    add(Params, Regs, Pc, Rn, Pcn).

exec_inst("jmpe" ,Params, Regs, Pc, Rn, Pcn):-
    jmpe(Params, Regs, Pc, Rn, Pcn).

exec_inst("prn" ,Params, Regs, Pc, Rn, Pcn):-
    prn(Params, Regs, Pc, Rn, Pcn).

exec_inst("jmpu" ,Params, Regs, Pc, Rn, Pcn):-
    jmpu(Params, Regs, Pc, Rn, Pcn).

exec_inst("halt" ,Params, Regs, Pc, Rn, Pcn):-
    halt(Params, Regs, Pc, Rn, Pcn).


%instructions implementation:

%put: you can assign a constant integer to a register with put
%command. For example,put 24,r5
%assigns (puts) (constant) integer 24 into register r5
put(Params, Regs, Pc, Rn,Pcn):-
    %split parameters:
    split_string(Params ,"," , "", [Numstr,Regstr]),

    %convert from string to int:
    atom_number(Numstr, Numint),

    %remove the 'r' prefix from Regstr:
    rem_prefix(Regstr,Rindex),
    set_value(Rindex, Numint, Regs, Rn),
    Pcn is Pc + 1.


%add r1,r2 adds values at r1, r2 and puts sum at r2
add(Params, Regs, Pc, Rn, Pcn):-
    %split parameters
    split_string(Params ,"," ,"", [Reg1, Reg2]),

    %removing the 'r' prefix and getting Index as integer
    rem_prefix(Reg1, Index1),
    rem_prefix(Reg2, Index2),

    %getting values
    get_value(Index1, Regs, V1),
    get_value(Index2, Regs, V2),

    %adding values:
    Sum is V1 + V2,

    %putting sum in Index2
    set_value(Index2, Sum, Regs, Rn),
    Pcn is Pc + 1.


jmpe(Params, Regs, Pc, Regs, PcNew) :-
    split_string(Params, ",", "", [R1, R2, LineNum]),
    rem_prefix(R1, I1),
    rem_prefix(R2, I2),
    get_value(I1, Regs, V1),
    get_value(I2, Regs, V2),
    atom_number(LineNum, TargetLine),
    (V1 =:= V2 -> PcNew = TargetLine ; PcNew is Pc + 1).



%jmpu X, given an integer X set pc value to X
jmpu(Params, Regs, _, Regs, Pcn):-
    atom_number(Params, Pcn).

%prn r*, print the content of r*
prn(Params, Regs, Pc, Regs, Pcn):-
    rem_prefix(Params,Index),
    get_value(Index, Regs, Value),
    writeln(Value),
    Pcn is Pc + 1.

halt(_,Regs,_,Regs,Pcn):-
    Pcn is 0.



%printing all lines from the file :
printFile(FileName):-
    open(FileName, read , Stream),
    print_stream(Stream),
    close(Stream).

%to read and print each line:

print_stream(Stream):- at_end_of_stream(Stream),!.

print_stream(Stream):-
    %read a line:
    read_line_to_string(Stream, Line),

    %print the line:
    writeln(Line),

    %process next line:
    print_stream(Stream).



%Helper predicates:
%given an index and a list return the ith element:
getIth(1 , [H|_], H).

getIth(Index,[_|T],Ith):-
    Index > 1,
    In is Index - 1, getIth(In,T,Ith).

%append to the end of a list:
appende([],X,[X]).
appende([H|T],X,Lf):-
    appende(T,X,L2),
    Lf = [H|L2].

% read_all_lines reads all lines from a filestream and reurns a list of
% those lines in the same order
read_all_lines(Stream,[]):- at_end_of_stream(Stream),!.

read_all_lines(Stream,[Line|Lines]):-
    read_line_to_string(Stream,Line),
    read_all_lines(Stream,Lines).

% given an index and an array and a value , set the ith element to value
% , note : array indecies start from 1
set_value(1,Value,[_|T],[Value|T]).

set_value(Index,Value,[H|T],[H|Tn]):-
    Index > 1,
    In is Index - 1,
    set_value(In, Value, T, Tn).

%given an index and an array return the ith element
get_value(1,[H|_], H).
get_value(Index, [_|T] , Value):-
    Index > 1,
    In is Index - 1,
    get_value(In, T, Value).

%removes 'r' prefix and converts the number part into integer:
rem_prefix(Regstr,Index):-
    sub_string(Regstr, 1, _, 0, Indexstr),
    atom_number(Indexstr, Index).
