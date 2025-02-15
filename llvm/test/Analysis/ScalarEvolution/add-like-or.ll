; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

define i8 @or-of-constant-with-no-common-bits-set(i8 %x, i8 %y) {
; CHECK-LABEL: 'or-of-constant-with-no-common-bits-set'
; CHECK-NEXT:  Classifying expressions for: @or-of-constant-with-no-common-bits-set
; CHECK-NEXT:    %t0 = shl i8 %x, 2
; CHECK-NEXT:    --> (4 * %x) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %r = or disjoint i8 %t0, 3
; CHECK-NEXT:    --> (3 + (4 * %x))<nuw><nsw> U: [3,0) S: [-125,-128)
; CHECK-NEXT:  Determining loop execution counts for: @or-of-constant-with-no-common-bits-set
;
  %t0 = shl i8 %x, 2
  %r = or disjoint i8 %t0, 3
  ret i8 %r
}

define i8 @or-disjoint(i8 %x, i8 %y) {
; CHECK-LABEL: 'or-disjoint'
; CHECK-NEXT:  Classifying expressions for: @or-disjoint
; CHECK-NEXT:    %or = or disjoint i8 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @or-disjoint
;
  %or = or disjoint i8 %x, %y
  ret i8 %or
}

define i8 @or-no-disjoint(i8 %x, i8 %y) {
; CHECK-LABEL: 'or-no-disjoint'
; CHECK-NEXT:  Classifying expressions for: @or-no-disjoint
; CHECK-NEXT:    %or = or i8 %x, %y
; CHECK-NEXT:    --> %or U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @or-no-disjoint
;
  %or = or i8 %x, %y
  ret i8 %or
}

; FIXME: We could add nuw nsw flags here.
define noundef i8 @or-disjoint-transfer-flags(i8 %x, i8 %y) {
; CHECK-LABEL: 'or-disjoint-transfer-flags'
; CHECK-NEXT:  Classifying expressions for: @or-disjoint-transfer-flags
; CHECK-NEXT:    %or = or disjoint i8 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @or-disjoint-transfer-flags
;
  %or = or disjoint i8 %x, %y
  ret i8 %or
}

define void @mask-high(i64 %arg, ptr dereferenceable(4) %arg1) {
; CHECK-LABEL: 'mask-high'
; CHECK-NEXT:  Classifying expressions for: @mask-high
; CHECK-NEXT:    %i = load i32, ptr %arg1, align 4
; CHECK-NEXT:    --> %i U: full-set S: full-set
; CHECK-NEXT:    %i2 = sext i32 %i to i64
; CHECK-NEXT:    --> (sext i32 %i to i64) U: [-2147483648,2147483648) S: [-2147483648,2147483648)
; CHECK-NEXT:    %i3 = and i64 %arg, -16
; CHECK-NEXT:    --> (16 * (%arg /u 16))<nuw> U: [0,-15) S: [-9223372036854775808,9223372036854775793)
; CHECK-NEXT:    %i4 = or disjoint i64 1, %i3
; CHECK-NEXT:    --> (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw> U: [1,-14) S: [-9223372036854775807,9223372036854775794)
; CHECK-NEXT:    %i7 = phi i64 [ %i4, %bb ], [ %i8, %bb6 ]
; CHECK-NEXT:    --> {(1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>,+,1}<%bb6> U: full-set S: full-set Exits: ((sext i32 %i to i64) smax (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>) LoopDispositions: { %bb6: Computable }
; CHECK-NEXT:    %i8 = add i64 %i7, 1
; CHECK-NEXT:    --> {(2 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>,+,1}<%bb6> U: full-set S: full-set Exits: (1 + ((sext i32 %i to i64) smax (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>))<nsw> LoopDispositions: { %bb6: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @mask-high
; CHECK-NEXT:  Loop %bb6: backedge-taken count is (-1 + (-16 * (%arg /u 16)) + ((sext i32 %i to i64) smax (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>))
; CHECK-NEXT:  Loop %bb6: constant max backedge-taken count is i64 -9223372034707292162
; CHECK-NEXT:  Loop %bb6: symbolic max backedge-taken count is (-1 + (-16 * (%arg /u 16)) + ((sext i32 %i to i64) smax (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>))
; CHECK-NEXT:  Loop %bb6: Predicated backedge-taken count is (-1 + (-16 * (%arg /u 16)) + ((sext i32 %i to i64) smax (1 + (16 * (%arg /u 16))<nuw>)<nuw><nsw>))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %bb6: Trip multiple is 1
;
bb:
  %i = load i32, ptr %arg1, align 4
  %i2 = sext i32 %i to i64
  %i3 = and i64 %arg, -16
  %i4 = or disjoint i64 1, %i3
  %i5 = icmp sgt i64 %i4, %i2
  br i1 %i5, label %bb10, label %bb6

bb6:                                              ; preds = %bb6, %bb
  %i7 = phi i64 [ %i4, %bb ], [ %i8, %bb6 ]
  %i8 = add i64 %i7, 1
  %i9 = icmp slt i64 %i7, %i2
  br i1 %i9, label %bb6, label %bb10

bb10:                                             ; preds = %bb6, %bb
  ret void
}
