; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

; Tests demonstrate the bug reported as PR48225 by Congzhe Cao.

; When %boolcond = false and %cond = 0:
; - %cond.false.on.first.iter is false on 1st iteration;
; - %cond.false.on.second.iter is false on 2nd iteration;
; - Therefore, their AND is false on first two iterations, and the backedge is taken twice.
;  'constant max backedge-taken count is 1' is a bug caused by wrong treatment of AND
;  condition in the computation logic. It should be 2.
define void @test_and(i1 %boolcond) {
; CHECK-LABEL: 'test_and'
; CHECK-NEXT:  Classifying expressions for: @test_and
; CHECK-NEXT:    %conv = zext i1 %boolcond to i32
; CHECK-NEXT:    --> (zext i1 %boolcond to i32) U: [0,2) S: [0,2)
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %inc, %backedge ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,3) S: [0,3) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or.cond = and i1 %cond.false.on.first.iter, %cond.false.on.second.iter
; CHECK-NEXT:    --> (%cond.false.on.first.iter umin %cond.false.on.second.iter) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %inc = add nuw nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,4) S: [1,4) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @test_and
; CHECK-NEXT:  Loop %loop: <multiple exits> Unpredictable backedge-taken count.
; CHECK-NEXT:    exit count for loop: 2
; CHECK-NEXT:    exit count for backedge: ***COULDNOTCOMPUTE***
; CHECK-NEXT:  Loop %loop: constant max backedge-taken count is i32 2
; CHECK-NEXT:  Loop %loop: symbolic max backedge-taken count is 2
; CHECK-NEXT:    symbolic max exit count for loop: 2
; CHECK-NEXT:    symbolic max exit count for backedge: ***COULDNOTCOMPUTE***
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  %conv = zext i1 %boolcond to i32
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %inc, %backedge ]
  %cmp = icmp ult i32 %iv, 2
  br i1 %cmp, label %backedge, label %for.end

backedge:
  %cond.false.on.first.iter = icmp ne i32 %iv, 0
  %cond.false.on.second.iter = icmp eq i32 %iv, %conv
  %or.cond = and i1 %cond.false.on.first.iter, %cond.false.on.second.iter
  %inc = add nuw nsw i32 %iv, 1
  br i1 %or.cond, label %exit, label %loop

exit:
  unreachable

for.end:
  ret void
}

; When %boolcond = false and %cond = 0:
; - %cond.true.on.first.iter is true on 1st iteration;
; - %cond.true.on.second.iter is true on 2nd iteration;
; - Therefore, their OR is true on first two iterations, and the backedge is taken twice.
;  'constant max backedge-taken count is 1' is a bug caused by wrong treatment of OR
;  condition in the computation logic. It should be 2.
define void @test_or(i1 %boolcond) {
; CHECK-LABEL: 'test_or'
; CHECK-NEXT:  Classifying expressions for: @test_or
; CHECK-NEXT:    %conv = zext i1 %boolcond to i32
; CHECK-NEXT:    --> (zext i1 %boolcond to i32) U: [0,2) S: [0,2)
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %inc, %backedge ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,3) S: [0,3) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or.cond = or i1 %cond.true.on.first.iter, %cond.true.on.second.iter
; CHECK-NEXT:    --> (%cond.true.on.first.iter umax %cond.true.on.second.iter) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %inc = add nuw nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,4) S: [1,4) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @test_or
; CHECK-NEXT:  Loop %loop: <multiple exits> Unpredictable backedge-taken count.
; CHECK-NEXT:    exit count for loop: 2
; CHECK-NEXT:    exit count for backedge: ***COULDNOTCOMPUTE***
; CHECK-NEXT:  Loop %loop: constant max backedge-taken count is i32 2
; CHECK-NEXT:  Loop %loop: symbolic max backedge-taken count is 2
; CHECK-NEXT:    symbolic max exit count for loop: 2
; CHECK-NEXT:    symbolic max exit count for backedge: ***COULDNOTCOMPUTE***
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  %conv = zext i1 %boolcond to i32
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %inc, %backedge ]
  %cmp = icmp ult i32 %iv, 2
  br i1 %cmp, label %backedge, label %for.end

backedge:
  %cond.true.on.first.iter = icmp eq i32 %iv, 0
  %cond.true.on.second.iter = icmp ne i32 %iv, %conv
  %or.cond = or i1 %cond.true.on.first.iter, %cond.true.on.second.iter
  %inc = add nuw nsw i32 %iv, 1
  br i1 %or.cond, label %loop, label %exit

exit:
  unreachable

for.end:
  ret void
}
