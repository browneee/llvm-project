; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -S -disable-output "-passes=print<scalar-evolution>" -scalar-evolution-classify-expressions=0 < %s 2>&1 | FileCheck %s

define void @s32_max1(i32 %n, ptr %p) {
; CHECK-LABEL: 's32_max1'
; CHECK-NEXT:  Determining loop execution counts for: @s32_max1
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((1 + %n) smax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 1, actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((1 + %n) smax %n)), actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((1 + %n) smax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 1
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp slt i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or 1 times

do.end:
  ret void
}

define void @s32_max2(i32 %n, ptr %p) {
; CHECK-LABEL: 's32_max2'
; CHECK-NEXT:  Determining loop execution counts for: @s32_max2
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((2 + %n) smax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 2, actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((2 + %n) smax %n)), actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((2 + %n) smax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 2
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp slt i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or 2 times

do.end:
  ret void
}

define void @s32_maxx(i32 %n, i32 %x, ptr %p) {
; CHECK-LABEL: 's32_maxx'
; CHECK-NEXT:  Determining loop execution counts for: @s32_maxx
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((%n + %x) smax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 -1
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((%n + %x) smax %n))
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((%n + %x) smax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %x, %n
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp slt i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or x times

do.end:
  ret void
}

define void @s32_max2_unpredictable_exit(i32 %n, i32 %x, ptr %p) {
; CHECK-LABEL: 's32_max2_unpredictable_exit'
; CHECK-NEXT:  Determining loop execution counts for: @s32_max2_unpredictable_exit
; CHECK-NEXT:  Loop %do.body: <multiple exits> backedge-taken count is (((-1 * %n) + ((2 + %n) smax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:    exit count for do.body: ((-1 * %n) + %x)
; CHECK-NEXT:    exit count for if.end: ((-1 * %n) + ((2 + %n) smax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 2
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is (((-1 * %n) + ((2 + %n) smax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:    symbolic max exit count for do.body: ((-1 * %n) + %x)
; CHECK-NEXT:    symbolic max exit count for if.end: ((-1 * %n) + ((2 + %n) smax %n))
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is (((-1 * %n) + ((2 + %n) smax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 2
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %if.end ]
  %cmp = icmp eq i32 %i.0, %x
  br i1 %cmp, label %do.end, label %if.end ; unpredictable

if.end:
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp1 = icmp slt i32 %i.0, %add
  br i1 %cmp1, label %do.body, label %do.end ; taken either 0 or 2 times

do.end:
  ret void
}

define void @u32_max1(i32 %n, ptr %p) {
; CHECK-LABEL: 'u32_max1'
; CHECK-NEXT:  Determining loop execution counts for: @u32_max1
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((1 + %n) umax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 1, actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((1 + %n) umax %n)), actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((1 + %n) umax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 1
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp ult i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or 1 times

do.end:
  ret void
}

define void @u32_max2(i32 %n, ptr %p) {
; CHECK-LABEL: 'u32_max2'
; CHECK-NEXT:  Determining loop execution counts for: @u32_max2
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((2 + %n) umax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 2, actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((2 + %n) umax %n)), actual taken count either this or zero.
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((2 + %n) umax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 2
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp ult i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or 2 times

do.end:
  ret void
}

define void @u32_maxx(i32 %n, i32 %x, ptr %p) {
; CHECK-LABEL: 'u32_maxx'
; CHECK-NEXT:  Determining loop execution counts for: @u32_maxx
; CHECK-NEXT:  Loop %do.body: backedge-taken count is ((-1 * %n) + ((%n + %x) umax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 -1
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is ((-1 * %n) + ((%n + %x) umax %n))
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is ((-1 * %n) + ((%n + %x) umax %n))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %x, %n
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %do.body ]
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp = icmp ult i32 %i.0, %add
  br i1 %cmp, label %do.body, label %do.end ; taken either 0 or x times

do.end:
  ret void
}

define void @u32_max2_unpredictable_exit(i32 %n, i32 %x, ptr %p) {
; CHECK-LABEL: 'u32_max2_unpredictable_exit'
; CHECK-NEXT:  Determining loop execution counts for: @u32_max2_unpredictable_exit
; CHECK-NEXT:  Loop %do.body: <multiple exits> backedge-taken count is (((-1 * %n) + ((2 + %n) umax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:    exit count for do.body: ((-1 * %n) + %x)
; CHECK-NEXT:    exit count for if.end: ((-1 * %n) + ((2 + %n) umax %n))
; CHECK-NEXT:  Loop %do.body: constant max backedge-taken count is i32 2
; CHECK-NEXT:  Loop %do.body: symbolic max backedge-taken count is (((-1 * %n) + ((2 + %n) umax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:    symbolic max exit count for do.body: ((-1 * %n) + %x)
; CHECK-NEXT:    symbolic max exit count for if.end: ((-1 * %n) + ((2 + %n) umax %n))
; CHECK-NEXT:  Loop %do.body: Predicated backedge-taken count is (((-1 * %n) + ((2 + %n) umax %n)) umin ((-1 * %n) + %x))
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %do.body: Trip multiple is 1
;
entry:
  %add = add i32 %n, 2
  br label %do.body

do.body:
  %i.0 = phi i32 [ %n, %entry ], [ %inc, %if.end ]
  %cmp = icmp eq i32 %i.0, %x
  br i1 %cmp, label %do.end, label %if.end ; unpredictable

if.end:
  %arrayidx = getelementptr i32, ptr %p, i32 %i.0
  store i32 %i.0, ptr %arrayidx, align 4
  %inc = add i32 %i.0, 1
  %cmp1 = icmp ult i32 %i.0, %add
  br i1 %cmp1, label %do.body, label %do.end ; taken either 0 or 2 times

do.end:
  ret void
}
