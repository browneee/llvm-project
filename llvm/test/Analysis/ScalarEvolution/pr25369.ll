; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --version 4
; RUN: opt -disable-output "-passes=print<scalar-evolution>" -scalar-evolution-classify-expressions=0 < %s 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @hoge1() {
;
; CHECK-LABEL: 'hoge1'
; CHECK-NEXT:  Determining loop execution counts for: @hoge1
; CHECK-NEXT:  Loop %bb13: backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:  Loop %bb13: constant max backedge-taken count is i32 -1
; CHECK-NEXT:  Loop %bb13: symbolic max backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:  Loop %bb13: Predicated backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %bb13: Trip multiple is 1
; CHECK-NEXT:  Loop %bb4: backedge-taken count is 20
; CHECK-NEXT:  Loop %bb4: constant max backedge-taken count is i64 20
; CHECK-NEXT:  Loop %bb4: symbolic max backedge-taken count is 20
; CHECK-NEXT:  Loop %bb4: Predicated backedge-taken count is 20
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %bb4: Trip multiple is 21
; CHECK-NEXT:  Loop %bb2: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable constant max backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable symbolic max backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable predicated backedge-taken count.
;
bb:
  br i1 undef, label %bb4, label %bb2

bb2:                                              ; preds = %bb2, %bb
  br i1 false, label %bb4, label %bb2

bb3:                                              ; preds = %bb4
  %tmp = add i32 %tmp10, -1
  br label %bb13

bb4:                                              ; preds = %bb4, %bb2, %bb
  %tmp5 = phi i64 [ %tmp11, %bb4 ], [ 1, %bb2 ], [ 1, %bb ]
  %tmp6 = phi i32 [ %tmp10, %bb4 ], [ 0, %bb2 ], [ 0, %bb ]
  %tmp7 = load i32, ptr undef, align 4
  %tmp8 = add i32 %tmp7, %tmp6
  %tmp9 = add i32 undef, %tmp8
  %tmp10 = add i32 undef, %tmp9
  %tmp11 = add nsw i64 %tmp5, 3
  %tmp12 = icmp eq i64 %tmp11, 64
  br i1 %tmp12, label %bb3, label %bb4


bb13:                                             ; preds = %bb13, %bb3
  %tmp14 = phi i64 [ 0, %bb3 ], [ %tmp15, %bb13 ]
  %tmp15 = add nuw nsw i64 %tmp14, 1
  %tmp16 = trunc i64 %tmp15 to i32
  %tmp17 = icmp eq i32 %tmp16, %tmp
  br i1 %tmp17, label %bb18, label %bb13

bb18:                                             ; preds = %bb13
  ret void
}

define void @hoge2() {
;
; CHECK-LABEL: 'hoge2'
; CHECK-NEXT:  Determining loop execution counts for: @hoge2
; CHECK-NEXT:  Loop %bb13: backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:  Loop %bb13: constant max backedge-taken count is i32 -1
; CHECK-NEXT:  Loop %bb13: symbolic max backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:  Loop %bb13: Predicated backedge-taken count is (-2 + (2 * undef) + %tmp7 + %tmp6)
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %bb13: Trip multiple is 1
; CHECK-NEXT:  Loop %bb4: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %bb4: Unpredictable constant max backedge-taken count.
; CHECK-NEXT:  Loop %bb4: Unpredictable symbolic max backedge-taken count.
; CHECK-NEXT:  Loop %bb4: Unpredictable predicated backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable constant max backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable symbolic max backedge-taken count.
; CHECK-NEXT:  Loop %bb2: Unpredictable predicated backedge-taken count.
;
bb:
  br i1 undef, label %bb4, label %bb2

bb2:                                              ; preds = %bb2, %bb
  br i1 false, label %bb4, label %bb2

bb3:                                              ; preds = %bb4
  %tmp = add i32 %tmp10, -1
  br label %bb13

bb4:                                              ; preds = %bb4, %bb2, %bb
  %tmp5 = phi i64 [ %tmp11, %bb4 ], [ 1, %bb2 ], [ 3, %bb ]
  %tmp6 = phi i32 [ %tmp10, %bb4 ], [ 0, %bb2 ], [ 0, %bb ]
  %tmp7 = load i32, ptr undef, align 4
  %tmp8 = add i32 %tmp7, %tmp6
  %tmp9 = add i32 undef, %tmp8
  %tmp10 = add i32 undef, %tmp9
  %tmp11 = add nsw i64 %tmp5, 3
  %tmp12 = icmp eq i64 %tmp11, 64
  br i1 %tmp12, label %bb3, label %bb4


bb13:                                             ; preds = %bb13, %bb3
  %tmp14 = phi i64 [ 0, %bb3 ], [ %tmp15, %bb13 ]
  %tmp15 = add nuw nsw i64 %tmp14, 1
  %tmp16 = trunc i64 %tmp15 to i32
  %tmp17 = icmp eq i32 %tmp16, %tmp
  br i1 %tmp17, label %bb18, label %bb13

bb18:                                             ; preds = %bb13
  ret void
}
