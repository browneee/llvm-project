; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --version 2
; RUN: opt -disable-output "-passes=print<scalar-evolution>" < %s 2>&1 | FileCheck %s

define i32 @f0(i32 %x, i32 %y) {
; CHECK-LABEL: 'f0'
; CHECK-NEXT:  Classifying expressions for: @f0
; CHECK-NEXT:    %sum = add i32 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:    %v = phi i32 [ %sum, %add ], [ %x, %entry ]
; CHECK-NEXT:    --> ((0 smax %y) + %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f0
;
entry:
  %c = icmp sgt i32 %y, 0
  br i1 %c, label %add, label %merge

add:
  %sum = add i32 %x, %y
  br label %merge

merge:
  %v = phi i32 [ %sum, %add ], [ %x, %entry ]
  ret i32 %v
}

define i32 @f1(i32 %x, i32 %y) {
; CHECK-LABEL: 'f1'
; CHECK-NEXT:  Classifying expressions for: @f1
; CHECK-NEXT:    %sum = add i32 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:    %v = phi i32 [ %sum, %add ], [ %x, %entry ]
; CHECK-NEXT:    --> ((0 smax %y) + %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f1
;
entry:
  %c = icmp sge i32 %y, 0
  br i1 %c, label %add, label %merge

add:
  %sum = add i32 %x, %y
  br label %merge

merge:
  %v = phi i32 [ %sum, %add ], [ %x, %entry ]
  ret i32 %v
}

define i32 @f2(i32 %x, i32 %y, ptr %ptr) {
; CHECK-LABEL: 'f2'
; CHECK-NEXT:  Classifying expressions for: @f2
; CHECK-NEXT:    %lv = load i32, ptr %ptr, align 4
; CHECK-NEXT:    --> %lv U: full-set S: full-set
; CHECK-NEXT:    %v = phi i32 [ %lv, %add ], [ %x, %entry ]
; CHECK-NEXT:    --> %v U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f2
;
entry:
  %c = icmp sge i32 %y, 0
  br i1 %c, label %add, label %merge

add:
  %lv = load i32, ptr %ptr
  br label %merge

merge:
  %v = phi i32 [ %lv, %add ], [ %x, %entry ]
  ret i32 %v
}

define i32 @f3(i32 %x, i32 %init, i32 %lim) {
; CHECK-LABEL: 'f3'
; CHECK-NEXT:  Classifying expressions for: @f3
; CHECK-NEXT:    %iv = phi i32 [ %init, %entry ], [ %iv.inc, %merge ]
; CHECK-NEXT:    --> {%init,+,1}<%loop> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add i32 %iv, 1
; CHECK-NEXT:    --> {(1 + %init),+,1}<%loop> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %sum = add i32 %x, %iv
; CHECK-NEXT:    --> {(%x + %init),+,1}<%loop> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %v = phi i32 [ %sum, %add ], [ %x, %loop ]
; CHECK-NEXT:    --> ((0 smax {%init,+,1}<%loop>) + %x) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @f3
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable constant max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable symbolic max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ %init, %entry ], [ %iv.inc, %merge ]
  %iv.inc = add i32 %iv, 1
  %c = icmp sge i32 %iv, 0
  br i1 %c, label %add, label %merge

add:
  %sum = add i32 %x, %iv
  br label %merge

merge:
  %v = phi i32 [ %sum, %add ], [ %x, %loop ]
  %be.cond = icmp eq i32 %iv.inc, %lim
  br i1 %be.cond, label %loop, label %leave

leave:
  ret i32 0
}

define i32 @f4(i32 %x, i32 %init, i32 %lim) {
; CHECK-LABEL: 'f4'
; CHECK-NEXT:  Classifying expressions for: @f4
; CHECK-NEXT:    %iv = phi i32 [ %init, %add ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {%init,+,1}<%loop> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add i32 %iv, 1
; CHECK-NEXT:    --> {(1 + %init),+,1}<%loop> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %sum = add i32 %x, %iv
; CHECK-NEXT:    --> {(%x + %init),+,1}<%loop> U: full-set S: full-set
; CHECK-NEXT:    %v = phi i32 [ %sum, %add.cont ], [ %x, %entry ]
; CHECK-NEXT:    --> %v U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f4
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable constant max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable symbolic max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  %c = icmp sge i32 %init, 0
  br i1 %c, label %add, label %merge

add:
  br label %loop

loop:
  %iv = phi i32 [ %init, %add ], [ %iv.inc, %loop ]
  %iv.inc = add i32 %iv, 1
  %be.cond = icmp eq i32 %iv.inc, %lim
  br i1 %be.cond, label %loop, label %add.cont

add.cont:
  %sum = add i32 %x, %iv
  br label %merge

merge:
  %v = phi i32 [ %sum, %add.cont ], [ %x, %entry ]
  ret i32 %v
}

; It's okay to match "through" %init, as SCEV expressions don't preserve LCSSA.
define i32 @f5(ptr %val) {
; CHECK-LABEL: 'f5'
; CHECK-NEXT:  Classifying expressions for: @f5
; CHECK-NEXT:    %inc = load i32, ptr %val, align 4
; CHECK-NEXT:    --> %inc U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.end: Variant }
; CHECK-NEXT:    %init = phi i32 [ 0, %for.condt ], [ %inc, %for.end ]
; CHECK-NEXT:    --> %inc U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f5
; CHECK-NEXT:  Loop %for.end: <multiple exits> backedge-taken count is false
; CHECK-NEXT:    exit count for for.end: false
; CHECK-NEXT:    exit count for for.condt: false
; CHECK-NEXT:  Loop %for.end: constant max backedge-taken count is i1 false
; CHECK-NEXT:  Loop %for.end: symbolic max backedge-taken count is false
; CHECK-NEXT:    symbolic max exit count for for.end: false
; CHECK-NEXT:    symbolic max exit count for for.condt: false
; CHECK-NEXT:  Loop %for.end: Predicated backedge-taken count is false
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %for.end: Trip multiple is 1
;
entry:
  br label %for.end

for.condt:
  br i1 true, label %for.cond.0, label %for.end

for.end:
  %inc = load i32, ptr %val
  br i1 false, label %for.condt, label %for.cond.0

for.cond.0:
  %init = phi i32 [ 0, %for.condt ], [ %inc, %for.end ]
  ret i32 %init
}

; Do the right thing for unreachable code:
define i32 @f6(i32 %x, i32 %y) {
; CHECK-LABEL: 'f6'
; CHECK-NEXT:  Classifying expressions for: @f6
; CHECK-NEXT:    %sum = add i32 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:    %v0 = phi i32 [ %sum, %entry ], [ %v1, %unreachable ]
; CHECK-NEXT:    --> %v0 U: full-set S: full-set
; CHECK-NEXT:    %v1 = phi i32 [ %v0, %merge ], [ 0, %leave_0_cond ]
; CHECK-NEXT:    --> %v1 U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f6
;
entry:
  %c0 = icmp sgt i32 %y, 0
  %sum = add i32 %x, %y
  br i1 %c0, label %merge, label %leave_1

merge:
  %v0 = phi i32 [ %sum, %entry ], [ %v1, %unreachable ]
  %c1 = icmp slt i32 %y, 0
  br i1 %c1, label %leave_0, label %leave_0_cond

leave_0_cond:
  br label %leave_0

leave_0:
  %v1 = phi i32 [ %v0, %merge ], [ 0, %leave_0_cond ]
  ret i32 0

leave_1:
  ret i32 0

unreachable:
  br label %merge
}
