; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Previously in this case the max backedge count would be computed as 1/0, which
; is correct but undesirable.  It would also not fold as a constant, tripping
; asserts in SCEV.

define void @pluto(i32 %arg) {
; CHECK-LABEL: 'pluto'
; CHECK-NEXT:  Classifying expressions for: @pluto
; CHECK-NEXT:    %tmp = ashr i32 %arg, 31
; CHECK-NEXT:    --> %tmp U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %tmp1 = add nsw i32 %tmp, 2
; CHECK-NEXT:    --> (2 + %tmp)<nsw> U: [1,3) S: [1,3)
; CHECK-NEXT:    %tmp3 = phi i32 [ 0, %bb ], [ %tmp4, %bb2 ]
; CHECK-NEXT:    --> {0,+,(2 + %tmp)<nsw>}<nuw><nsw><%bb2> U: [0,3) S: [0,3) Exits: ((2 + %tmp)<nsw> * (1 /u (2 + %tmp)<nsw>))<nuw> LoopDispositions: { %bb2: Computable }
; CHECK-NEXT:    %tmp4 = add nuw nsw i32 %tmp1, %tmp3
; CHECK-NEXT:    --> {(2 + %tmp)<nsw>,+,(2 + %tmp)<nsw>}<nuw><nsw><%bb2> U: [1,5) S: [1,5) Exits: (2 + ((2 + %tmp)<nsw> * (1 /u (2 + %tmp)<nsw>))<nuw> + %tmp) LoopDispositions: { %bb2: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @pluto
; CHECK-NEXT:  Loop %bb2: backedge-taken count is (1 /u (2 + %tmp)<nsw>)
; CHECK-NEXT:  Loop %bb2: constant max backedge-taken count is i32 1
; CHECK-NEXT:  Loop %bb2: symbolic max backedge-taken count is (1 /u (2 + %tmp)<nsw>)
; CHECK-NEXT:  Loop %bb2: Predicated backedge-taken count is (1 /u (2 + %tmp)<nsw>)
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %bb2: Trip multiple is 1
;
bb:
  %tmp = ashr i32 %arg, 31
  %tmp1 = add nsw i32 %tmp, 2
  br label %bb2

bb2:                                              ; preds = %bb2, %bb
  %tmp3 = phi i32 [ 0, %bb ], [ %tmp4, %bb2 ]
  %tmp4 = add nuw nsw i32 %tmp1, %tmp3
  %tmp5 = icmp ult i32 %tmp4, 2
  br i1 %tmp5, label %bb2, label %bb6

bb6:                                              ; preds = %bb2
  ret void
}
