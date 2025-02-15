; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s --data-layout="e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128" -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck --check-prefixes=ALL,X64 %s
; RUN: opt < %s --data-layout="e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128" -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck --check-prefixes=ALL,X32 %s

; While we can't treat inttoptr/ptrtoint casts as fully transparent,
; for ptrtoint cast, instead of modelling it as fully opaque (unknown),
; we can at least model it as zext/trunc/self of an unknown,
; iff it it's argument would be modelled as unknown anyways.

declare void @useptr(ptr)

; Simple ptrtoint of an argument, with casts to potentially different bit widths.
define void @ptrtoint(ptr %in, ptr %out0, ptr %out1, ptr %out2, ptr %out3) {
; X64-LABEL: 'ptrtoint'
; X64-NEXT:  Classifying expressions for: @ptrtoint
; X64-NEXT:    %p0 = ptrtoint ptr %in to i64
; X64-NEXT:    --> (ptrtoint ptr %in to i64) U: full-set S: full-set
; X64-NEXT:    %p1 = ptrtoint ptr %in to i32
; X64-NEXT:    --> (trunc i64 (ptrtoint ptr %in to i64) to i32) U: full-set S: full-set
; X64-NEXT:    %p2 = ptrtoint ptr %in to i16
; X64-NEXT:    --> (trunc i64 (ptrtoint ptr %in to i64) to i16) U: full-set S: full-set
; X64-NEXT:    %p3 = ptrtoint ptr %in to i128
; X64-NEXT:    --> (zext i64 (ptrtoint ptr %in to i64) to i128) U: [0,18446744073709551616) S: [0,18446744073709551616)
; X64-NEXT:  Determining loop execution counts for: @ptrtoint
;
; X32-LABEL: 'ptrtoint'
; X32-NEXT:  Classifying expressions for: @ptrtoint
; X32-NEXT:    %p0 = ptrtoint ptr %in to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %in to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %p1 = ptrtoint ptr %in to i32
; X32-NEXT:    --> (ptrtoint ptr %in to i32) U: full-set S: full-set
; X32-NEXT:    %p2 = ptrtoint ptr %in to i16
; X32-NEXT:    --> (trunc i32 (ptrtoint ptr %in to i32) to i16) U: full-set S: full-set
; X32-NEXT:    %p3 = ptrtoint ptr %in to i128
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %in to i32) to i128) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint
;
  %p0 = ptrtoint ptr %in to i64
  %p1 = ptrtoint ptr %in to i32
  %p2 = ptrtoint ptr %in to i16
  %p3 = ptrtoint ptr %in to i128
  store i64  %p0, ptr  %out0
  store i32  %p1, ptr  %out1
  store i16  %p2, ptr  %out2
  store i128 %p3, ptr %out3
  ret void
}

; Same, but from non-zero/non-default address space.
define void @ptrtoint_as1(ptr addrspace(1) %in, ptr %out0, ptr %out1, ptr %out2, ptr %out3) {
; X64-LABEL: 'ptrtoint_as1'
; X64-NEXT:  Classifying expressions for: @ptrtoint_as1
; X64-NEXT:    %p0 = ptrtoint ptr addrspace(1) %in to i64
; X64-NEXT:    --> (ptrtoint ptr addrspace(1) %in to i64) U: full-set S: full-set
; X64-NEXT:    %p1 = ptrtoint ptr addrspace(1) %in to i32
; X64-NEXT:    --> (trunc i64 (ptrtoint ptr addrspace(1) %in to i64) to i32) U: full-set S: full-set
; X64-NEXT:    %p2 = ptrtoint ptr addrspace(1) %in to i16
; X64-NEXT:    --> (trunc i64 (ptrtoint ptr addrspace(1) %in to i64) to i16) U: full-set S: full-set
; X64-NEXT:    %p3 = ptrtoint ptr addrspace(1) %in to i128
; X64-NEXT:    --> (zext i64 (ptrtoint ptr addrspace(1) %in to i64) to i128) U: [0,18446744073709551616) S: [0,18446744073709551616)
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_as1
;
; X32-LABEL: 'ptrtoint_as1'
; X32-NEXT:  Classifying expressions for: @ptrtoint_as1
; X32-NEXT:    %p0 = ptrtoint ptr addrspace(1) %in to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr addrspace(1) %in to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %p1 = ptrtoint ptr addrspace(1) %in to i32
; X32-NEXT:    --> (ptrtoint ptr addrspace(1) %in to i32) U: full-set S: full-set
; X32-NEXT:    %p2 = ptrtoint ptr addrspace(1) %in to i16
; X32-NEXT:    --> (trunc i32 (ptrtoint ptr addrspace(1) %in to i32) to i16) U: full-set S: full-set
; X32-NEXT:    %p3 = ptrtoint ptr addrspace(1) %in to i128
; X32-NEXT:    --> (zext i32 (ptrtoint ptr addrspace(1) %in to i32) to i128) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_as1
;
  %p0 = ptrtoint ptr addrspace(1) %in to i64
  %p1 = ptrtoint ptr addrspace(1) %in to i32
  %p2 = ptrtoint ptr addrspace(1) %in to i16
  %p3 = ptrtoint ptr addrspace(1) %in to i128
  store i64  %p0, ptr  %out0
  store i32  %p1, ptr  %out1
  store i16  %p2, ptr  %out2
  store i128 %p3, ptr %out3
  ret void
}

; Likewise, ptrtoint of a bitcast is fine, we simply skip it.
define void @ptrtoint_of_bitcast(ptr %in, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_bitcast'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_bitcast
; X64-NEXT:    %in_casted = bitcast ptr %in to ptr
; X64-NEXT:    --> %in U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %in_casted to i64
; X64-NEXT:    --> (ptrtoint ptr %in to i64) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_bitcast
;
; X32-LABEL: 'ptrtoint_of_bitcast'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_bitcast
; X32-NEXT:    %in_casted = bitcast ptr %in to ptr
; X32-NEXT:    --> %in U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %in_casted to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %in to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_bitcast
;
  %in_casted = bitcast ptr %in to ptr
  %p0 = ptrtoint ptr %in_casted to i64
  store i64 %p0, ptr %out0
  ret void
}

; addrspacecast is fine too, but We don't model addrspacecast, so we stop there.
define void @ptrtoint_of_addrspacecast(ptr %in, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_addrspacecast'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_addrspacecast
; X64-NEXT:    %in_casted = addrspacecast ptr %in to ptr addrspace(1)
; X64-NEXT:    --> %in_casted U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr addrspace(1) %in_casted to i64
; X64-NEXT:    --> (ptrtoint ptr addrspace(1) %in_casted to i64) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_addrspacecast
;
; X32-LABEL: 'ptrtoint_of_addrspacecast'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_addrspacecast
; X32-NEXT:    %in_casted = addrspacecast ptr %in to ptr addrspace(1)
; X32-NEXT:    --> %in_casted U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr addrspace(1) %in_casted to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr addrspace(1) %in_casted to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_addrspacecast
;
  %in_casted = addrspacecast ptr %in to ptr addrspace(1)
  %p0 = ptrtoint ptr addrspace(1) %in_casted to i64
  store i64 %p0, ptr %out0
  ret void
}

; inttoptr is fine too, but we don't (and can't) model inttoptr, so we stop there.
define void @ptrtoint_of_inttoptr(i64 %in, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_inttoptr'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_inttoptr
; X64-NEXT:    %in_casted = inttoptr i64 %in to ptr
; X64-NEXT:    --> %in_casted U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %in_casted to i64
; X64-NEXT:    --> (ptrtoint ptr %in_casted to i64) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_inttoptr
;
; X32-LABEL: 'ptrtoint_of_inttoptr'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_inttoptr
; X32-NEXT:    %in_casted = inttoptr i64 %in to ptr
; X32-NEXT:    --> %in_casted U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %in_casted to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %in_casted to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_inttoptr
;
  %in_casted = inttoptr i64 %in to ptr
  %p0 = ptrtoint ptr %in_casted to i64
  store i64 %p0, ptr %out0
  ret void
}

; A constant pointer is fine
define void @ptrtoint_of_nullptr(ptr %out0) {
; ALL-LABEL: 'ptrtoint_of_nullptr'
; ALL-NEXT:  Classifying expressions for: @ptrtoint_of_nullptr
; ALL-NEXT:    %p0 = ptrtoint ptr null to i64
; ALL-NEXT:    --> 0 U: [0,1) S: [0,1)
; ALL-NEXT:  Determining loop execution counts for: @ptrtoint_of_nullptr
;
  %p0 = ptrtoint ptr null to i64
  store i64 %p0, ptr %out0
  ret void
}

; A constant inttoptr argument of an ptrtoint is still bad.
define void @ptrtoint_of_constantexpr_inttoptr(ptr %out0) {
; X64-LABEL: 'ptrtoint_of_constantexpr_inttoptr'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_constantexpr_inttoptr
; X64-NEXT:    %p0 = ptrtoint ptr inttoptr (i64 42 to ptr) to i64
; X64-NEXT:    --> (ptrtoint ptr inttoptr (i64 42 to ptr) to i64) U: [42,43) S: [42,43)
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_constantexpr_inttoptr
;
; X32-LABEL: 'ptrtoint_of_constantexpr_inttoptr'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_constantexpr_inttoptr
; X32-NEXT:    %p0 = ptrtoint ptr inttoptr (i64 42 to ptr) to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr inttoptr (i64 42 to ptr) to i32) to i64) U: [42,43) S: [42,43)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_constantexpr_inttoptr
;
  %p0 = ptrtoint ptr inttoptr (i64 42 to ptr) to i64
  store i64 %p0, ptr %out0
  ret void
}

; ptrtoint of GEP is fine.
define void @ptrtoint_of_gep(ptr %in, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_gep'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_gep
; X64-NEXT:    %in_adj = getelementptr inbounds i8, ptr %in, i64 42
; X64-NEXT:    --> (42 + %in) U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %in_adj to i64
; X64-NEXT:    --> (42 + (ptrtoint ptr %in to i64)) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_gep
;
; X32-LABEL: 'ptrtoint_of_gep'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_gep
; X32-NEXT:    %in_adj = getelementptr inbounds i8, ptr %in, i64 42
; X32-NEXT:    --> (42 + %in) U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %in_adj to i64
; X32-NEXT:    --> (zext i32 (42 + (ptrtoint ptr %in to i32)) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_gep
;
  %in_adj = getelementptr inbounds i8, ptr %in, i64 42
  %p0 = ptrtoint ptr %in_adj to i64
  store i64  %p0, ptr  %out0
  ret void
}

; It seems, we can't get ptrtoint of mul/udiv, or at least it's hard to come up with a test case.

; ptrtoint of AddRec
define void @ptrtoint_of_addrec(ptr %in, i32 %count) {
; X64-LABEL: 'ptrtoint_of_addrec'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_addrec
; X64-NEXT:    %i3 = zext i32 %count to i64
; X64-NEXT:    --> (zext i32 %count to i64) U: [0,4294967296) S: [0,4294967296)
; X64-NEXT:    %i6 = phi i64 [ 0, %entry ], [ %i9, %loop ]
; X64-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-9223372036854775808) S: [0,-9223372036854775808) Exits: (-1 + (zext i32 %count to i64))<nsw> LoopDispositions: { %loop: Computable }
; X64-NEXT:    %i7 = getelementptr inbounds i32, ptr %in, i64 %i6
; X64-NEXT:    --> {%in,+,4}<%loop> U: full-set S: full-set Exits: (-4 + (4 * (zext i32 %count to i64))<nuw><nsw> + %in) LoopDispositions: { %loop: Computable }
; X64-NEXT:    %i8 = ptrtoint ptr %i7 to i64
; X64-NEXT:    --> {(ptrtoint ptr %in to i64),+,4}<%loop> U: full-set S: full-set Exits: (-4 + (4 * (zext i32 %count to i64))<nuw><nsw> + (ptrtoint ptr %in to i64)) LoopDispositions: { %loop: Computable }
; X64-NEXT:    %i9 = add nuw nsw i64 %i6, 1
; X64-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (zext i32 %count to i64) LoopDispositions: { %loop: Computable }
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_addrec
; X64-NEXT:  Loop %loop: backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X64-NEXT:  Loop %loop: constant max backedge-taken count is i64 -1
; X64-NEXT:  Loop %loop: symbolic max backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X64-NEXT:  Loop %loop: Predicated backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X64-NEXT:   Predicates:
; X64-NEXT:  Loop %loop: Trip multiple is 1
;
; X32-LABEL: 'ptrtoint_of_addrec'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_addrec
; X32-NEXT:    %i3 = zext i32 %count to i64
; X32-NEXT:    --> (zext i32 %count to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %i6 = phi i64 [ 0, %entry ], [ %i9, %loop ]
; X32-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-9223372036854775808) S: [0,-9223372036854775808) Exits: (-1 + (zext i32 %count to i64))<nsw> LoopDispositions: { %loop: Computable }
; X32-NEXT:    %i7 = getelementptr inbounds i32, ptr %in, i64 %i6
; X32-NEXT:    --> {%in,+,4}<%loop> U: full-set S: full-set Exits: (-4 + (4 * %count) + %in) LoopDispositions: { %loop: Computable }
; X32-NEXT:    %i8 = ptrtoint ptr %i7 to i64
; X32-NEXT:    --> (zext i32 {(ptrtoint ptr %in to i32),+,4}<%loop> to i64) U: [0,4294967296) S: [0,4294967296) Exits: (zext i32 (-4 + (4 * %count) + (ptrtoint ptr %in to i32)) to i64) LoopDispositions: { %loop: Computable }
; X32-NEXT:    %i9 = add nuw nsw i64 %i6, 1
; X32-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (zext i32 %count to i64) LoopDispositions: { %loop: Computable }
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_addrec
; X32-NEXT:  Loop %loop: backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X32-NEXT:  Loop %loop: constant max backedge-taken count is i64 -1
; X32-NEXT:  Loop %loop: symbolic max backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X32-NEXT:  Loop %loop: Predicated backedge-taken count is (-1 + (zext i32 %count to i64))<nsw>
; X32-NEXT:   Predicates:
; X32-NEXT:  Loop %loop: Trip multiple is 1
;
entry:
  %i3 = zext i32 %count to i64
  br label %loop

loop:
  %i6 = phi i64 [ 0, %entry ], [ %i9, %loop ]
  %i7 = getelementptr inbounds i32, ptr %in, i64 %i6
  %i8 = ptrtoint ptr %i7 to i64
  tail call void @use(i64 %i8)
  %i9 = add nuw nsw i64 %i6, 1
  %i10 = icmp eq i64 %i9, %i3
  br i1 %i10, label %end, label %loop

end:
  ret void
}
declare void @use(i64)

; ptrtoint of UMax
define void @ptrtoint_of_umax(ptr %in0, ptr %in1, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_umax'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_umax
; X64-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X64-NEXT:    --> (%in0 umax %in1) U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %s to i64
; X64-NEXT:    --> ((ptrtoint ptr %in0 to i64) umax (ptrtoint ptr %in1 to i64)) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_umax
;
; X32-LABEL: 'ptrtoint_of_umax'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_umax
; X32-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X32-NEXT:    --> (%in0 umax %in1) U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %s to i64
; X32-NEXT:    --> ((zext i32 (ptrtoint ptr %in0 to i32) to i64) umax (zext i32 (ptrtoint ptr %in1 to i32) to i64)) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_umax
;
  %c = icmp uge ptr %in0, %in1
  %s = select i1 %c, ptr %in0, ptr %in1
  %p0 = ptrtoint ptr %s to i64
  store i64  %p0, ptr  %out0
  ret void
}
; ptrtoint of SMax
define void @ptrtoint_of_smax(ptr %in0, ptr %in1, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_smax'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_smax
; X64-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X64-NEXT:    --> (%in0 smax %in1) U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %s to i64
; X64-NEXT:    --> ((ptrtoint ptr %in0 to i64) smax (ptrtoint ptr %in1 to i64)) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_smax
;
; X32-LABEL: 'ptrtoint_of_smax'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_smax
; X32-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X32-NEXT:    --> (%in0 smax %in1) U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %s to i64
; X32-NEXT:    --> (zext i32 ((ptrtoint ptr %in0 to i32) smax (ptrtoint ptr %in1 to i32)) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_smax
;
  %c = icmp sge ptr %in0, %in1
  %s = select i1 %c, ptr %in0, ptr %in1
  %p0 = ptrtoint ptr %s to i64
  store i64  %p0, ptr  %out0
  ret void
}
; ptrtoint of UMin
define void @ptrtoint_of_umin(ptr %in0, ptr %in1, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_umin'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_umin
; X64-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X64-NEXT:    --> (%in0 umin %in1) U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %s to i64
; X64-NEXT:    --> ((ptrtoint ptr %in0 to i64) umin (ptrtoint ptr %in1 to i64)) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_umin
;
; X32-LABEL: 'ptrtoint_of_umin'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_umin
; X32-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X32-NEXT:    --> (%in0 umin %in1) U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %s to i64
; X32-NEXT:    --> ((zext i32 (ptrtoint ptr %in0 to i32) to i64) umin (zext i32 (ptrtoint ptr %in1 to i32) to i64)) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_umin
;
  %c = icmp ule ptr %in0, %in1
  %s = select i1 %c, ptr %in0, ptr %in1
  %p0 = ptrtoint ptr %s to i64
  store i64  %p0, ptr  %out0
  ret void
}
; ptrtoint of SMin
define void @ptrtoint_of_smin(ptr %in0, ptr %in1, ptr %out0) {
; X64-LABEL: 'ptrtoint_of_smin'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_smin
; X64-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X64-NEXT:    --> (%in0 smin %in1) U: full-set S: full-set
; X64-NEXT:    %p0 = ptrtoint ptr %s to i64
; X64-NEXT:    --> ((ptrtoint ptr %in0 to i64) smin (ptrtoint ptr %in1 to i64)) U: full-set S: full-set
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_smin
;
; X32-LABEL: 'ptrtoint_of_smin'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_smin
; X32-NEXT:    %s = select i1 %c, ptr %in0, ptr %in1
; X32-NEXT:    --> (%in0 smin %in1) U: full-set S: full-set
; X32-NEXT:    %p0 = ptrtoint ptr %s to i64
; X32-NEXT:    --> (zext i32 ((ptrtoint ptr %in0 to i32) smin (ptrtoint ptr %in1 to i32)) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_smin
;
  %c = icmp sle ptr %in0, %in1
  %s = select i1 %c, ptr %in0, ptr %in1
  %p0 = ptrtoint ptr %s to i64
  store i64  %p0, ptr  %out0
  ret void
}

; void pr46786_c26_char(char* start, char *end, char *other) {
;   for (char* cur = start; cur != end; ++cur)
;     other[cur - start] += *cur;
; }
define void @pr46786_c26_char(ptr %arg, ptr %arg1, ptr %arg2) {
; X64-LABEL: 'pr46786_c26_char'
; X64-NEXT:  Classifying expressions for: @pr46786_c26_char
; X64-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X64-NEXT:    --> (ptrtoint ptr %arg to i64) U: full-set S: full-set
; X64-NEXT:    %i7 = phi ptr [ %arg, %bb3 ], [ %i14, %bb6 ]
; X64-NEXT:    --> {%arg,+,1}<nuw><%bb6> U: full-set S: full-set Exits: (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64) + %arg) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i8 = load i8, ptr %i7, align 1
; X64-NEXT:    --> %i8 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i9 = ptrtoint ptr %i7 to i64
; X64-NEXT:    --> {(ptrtoint ptr %arg to i64),+,1}<nuw><%bb6> U: full-set S: full-set Exits: (-1 + (ptrtoint ptr %arg1 to i64)) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i10 = sub i64 %i9, %i4
; X64-NEXT:    --> {0,+,1}<nuw><%bb6> U: full-set S: full-set Exits: (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i11 = getelementptr inbounds i8, ptr %arg2, i64 %i10
; X64-NEXT:    --> {%arg2,+,1}<nw><%bb6> U: full-set S: full-set Exits: (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64) + %arg2) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i12 = load i8, ptr %i11, align 1
; X64-NEXT:    --> %i12 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i13 = add i8 %i12, %i8
; X64-NEXT:    --> (%i12 + %i8) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i14 = getelementptr inbounds i8, ptr %i7, i64 1
; X64-NEXT:    --> {(1 + %arg),+,1}<nuw><%bb6> U: full-set S: full-set Exits: ((-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64) + %arg) LoopDispositions: { %bb6: Computable }
; X64-NEXT:  Determining loop execution counts for: @pr46786_c26_char
; X64-NEXT:  Loop %bb6: backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64))
; X64-NEXT:  Loop %bb6: constant max backedge-taken count is i64 -1
; X64-NEXT:  Loop %bb6: symbolic max backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64))
; X64-NEXT:  Loop %bb6: Predicated backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64))
; X64-NEXT:   Predicates:
; X64-NEXT:  Loop %bb6: Trip multiple is 1
;
; X32-LABEL: 'pr46786_c26_char'
; X32-NEXT:  Classifying expressions for: @pr46786_c26_char
; X32-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %arg to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %i7 = phi ptr [ %arg, %bb3 ], [ %i14, %bb6 ]
; X32-NEXT:    --> {%arg,+,1}<nuw><%bb6> U: full-set S: full-set Exits: (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32) + %arg) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i8 = load i8, ptr %i7, align 1
; X32-NEXT:    --> %i8 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i9 = ptrtoint ptr %i7 to i64
; X32-NEXT:    --> {(zext i32 (ptrtoint ptr %arg to i32) to i64),+,1}<nuw><%bb6> U: [0,8589934591) S: [0,8589934591) Exits: ((zext i32 (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) to i64) + (zext i32 (ptrtoint ptr %arg to i32) to i64)) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i10 = sub i64 %i9, %i4
; X32-NEXT:    --> {0,+,1}<nuw><%bb6> U: [0,4294967296) S: [0,4294967296) Exits: (zext i32 (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) to i64) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i11 = getelementptr inbounds i8, ptr %arg2, i64 %i10
; X32-NEXT:    --> {%arg2,+,1}<%bb6> U: full-set S: full-set Exits: (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32) + %arg2) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i12 = load i8, ptr %i11, align 1
; X32-NEXT:    --> %i12 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i13 = add i8 %i12, %i8
; X32-NEXT:    --> (%i12 + %i8) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i14 = getelementptr inbounds i8, ptr %i7, i64 1
; X32-NEXT:    --> {(1 + %arg),+,1}<nuw><%bb6> U: full-set S: full-set Exits: ((-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32) + %arg) LoopDispositions: { %bb6: Computable }
; X32-NEXT:  Determining loop execution counts for: @pr46786_c26_char
; X32-NEXT:  Loop %bb6: backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32))
; X32-NEXT:  Loop %bb6: constant max backedge-taken count is i32 -1
; X32-NEXT:  Loop %bb6: symbolic max backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32))
; X32-NEXT:  Loop %bb6: Predicated backedge-taken count is (-1 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32))
; X32-NEXT:   Predicates:
; X32-NEXT:  Loop %bb6: Trip multiple is 1
;
  %i = icmp eq ptr %arg, %arg1
  br i1 %i, label %bb5, label %bb3

bb3:
  %i4 = ptrtoint ptr %arg to i64
  br label %bb6

bb6:
  %i7 = phi ptr [ %arg, %bb3 ], [ %i14, %bb6 ]
  %i8 = load i8, ptr %i7
  %i9 = ptrtoint ptr %i7 to i64
  %i10 = sub i64 %i9, %i4
  %i11 = getelementptr inbounds i8, ptr %arg2, i64 %i10
  %i12 = load i8, ptr %i11
  %i13 = add i8 %i12, %i8
  store i8 %i13, ptr %i11
  %i14 = getelementptr inbounds i8, ptr %i7, i64 1
  %i15 = icmp eq ptr %i14, %arg1
  br i1 %i15, label %bb5, label %bb6

bb5:
  ret void
}

; void pr46786_c26_int(int* start, int *end, int *other) {
;   for (int* cur = start; cur != end; ++cur)
;     other[cur - start] += *cur;
; }
;
; FIXME: 4 * (%i10 EXACT/s 4) is just %i10
define void @pr46786_c26_int(ptr %arg, ptr %arg1, ptr %arg2) {
; X64-LABEL: 'pr46786_c26_int'
; X64-NEXT:  Classifying expressions for: @pr46786_c26_int
; X64-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X64-NEXT:    --> (ptrtoint ptr %arg to i64) U: full-set S: full-set
; X64-NEXT:    %i7 = phi ptr [ %arg, %bb3 ], [ %i15, %bb6 ]
; X64-NEXT:    --> {%arg,+,4}<nuw><%bb6> U: full-set S: full-set Exits: ((4 * ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4))<nuw> + %arg) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i8 = load i32, ptr %i7, align 4
; X64-NEXT:    --> %i8 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i9 = ptrtoint ptr %i7 to i64
; X64-NEXT:    --> {(ptrtoint ptr %arg to i64),+,4}<nuw><%bb6> U: full-set S: full-set Exits: ((4 * ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4))<nuw> + (ptrtoint ptr %arg to i64)) LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i10 = sub i64 %i9, %i4
; X64-NEXT:    --> {0,+,4}<nuw><%bb6> U: [0,-3) S: [-9223372036854775808,9223372036854775805) Exits: (4 * ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4))<nuw> LoopDispositions: { %bb6: Computable }
; X64-NEXT:    %i11 = ashr exact i64 %i10, 2
; X64-NEXT:    --> %i11 U: [-2305843009213693952,2305843009213693952) S: [-2305843009213693952,2305843009213693952) Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i12 = getelementptr inbounds i32, ptr %arg2, i64 %i11
; X64-NEXT:    --> ((4 * %i11)<nsw> + %arg2) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i13 = load i32, ptr %i12, align 4
; X64-NEXT:    --> %i13 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i14 = add nsw i32 %i13, %i8
; X64-NEXT:    --> (%i13 + %i8) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X64-NEXT:    %i15 = getelementptr inbounds i32, ptr %i7, i64 1
; X64-NEXT:    --> {(4 + %arg),+,4}<nuw><%bb6> U: full-set S: full-set Exits: (4 + (4 * ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4))<nuw> + %arg) LoopDispositions: { %bb6: Computable }
; X64-NEXT:  Determining loop execution counts for: @pr46786_c26_int
; X64-NEXT:  Loop %bb6: backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4)
; X64-NEXT:  Loop %bb6: constant max backedge-taken count is i64 4611686018427387903
; X64-NEXT:  Loop %bb6: symbolic max backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4)
; X64-NEXT:  Loop %bb6: Predicated backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i64)) + (ptrtoint ptr %arg1 to i64)) /u 4)
; X64-NEXT:   Predicates:
; X64-NEXT:  Loop %bb6: Trip multiple is 1
;
; X32-LABEL: 'pr46786_c26_int'
; X32-NEXT:  Classifying expressions for: @pr46786_c26_int
; X32-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %arg to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %i7 = phi ptr [ %arg, %bb3 ], [ %i15, %bb6 ]
; X32-NEXT:    --> {%arg,+,4}<nuw><%bb6> U: full-set S: full-set Exits: ((4 * ((-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) /u 4))<nuw> + %arg) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i8 = load i32, ptr %i7, align 4
; X32-NEXT:    --> %i8 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i9 = ptrtoint ptr %i7 to i64
; X32-NEXT:    --> {(zext i32 (ptrtoint ptr %arg to i32) to i64),+,4}<nuw><%bb6> U: [0,8589934588) S: [0,8589934588) Exits: ((zext i32 (ptrtoint ptr %arg to i32) to i64) + (4 * ((zext i32 (-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) to i64) /u 4))<nuw><nsw>) LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i10 = sub i64 %i9, %i4
; X32-NEXT:    --> {0,+,4}<nuw><%bb6> U: [0,4294967293) S: [0,4294967293) Exits: (4 * ((zext i32 (-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) to i64) /u 4))<nuw><nsw> LoopDispositions: { %bb6: Computable }
; X32-NEXT:    %i11 = ashr exact i64 %i10, 2
; X32-NEXT:    --> %i11 U: [-2147483648,2147483648) S: [-2147483648,2147483648) Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i12 = getelementptr inbounds i32, ptr %arg2, i64 %i11
; X32-NEXT:    --> ((4 * (trunc i64 %i11 to i32))<nsw> + %arg2) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i13 = load i32, ptr %i12, align 4
; X32-NEXT:    --> %i13 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i14 = add nsw i32 %i13, %i8
; X32-NEXT:    --> (%i13 + %i8) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb6: Variant }
; X32-NEXT:    %i15 = getelementptr inbounds i32, ptr %i7, i64 1
; X32-NEXT:    --> {(4 + %arg),+,4}<nuw><%bb6> U: full-set S: full-set Exits: (4 + (4 * ((-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) /u 4))<nuw> + %arg) LoopDispositions: { %bb6: Computable }
; X32-NEXT:  Determining loop execution counts for: @pr46786_c26_int
; X32-NEXT:  Loop %bb6: backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) /u 4)
; X32-NEXT:  Loop %bb6: constant max backedge-taken count is i32 1073741823
; X32-NEXT:  Loop %bb6: symbolic max backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) /u 4)
; X32-NEXT:  Loop %bb6: Predicated backedge-taken count is ((-4 + (-1 * (ptrtoint ptr %arg to i32)) + (ptrtoint ptr %arg1 to i32)) /u 4)
; X32-NEXT:   Predicates:
; X32-NEXT:  Loop %bb6: Trip multiple is 1
;
  %i = icmp eq ptr %arg, %arg1
  br i1 %i, label %bb5, label %bb3

bb3:
  %i4 = ptrtoint ptr %arg to i64
  br label %bb6

bb6:
  %i7 = phi ptr [ %arg, %bb3 ], [ %i15, %bb6 ]
  %i8 = load i32, ptr %i7
  %i9 = ptrtoint ptr %i7 to i64
  %i10 = sub i64 %i9, %i4
  %i11 = ashr exact i64 %i10, 2
  %i12 = getelementptr inbounds i32, ptr %arg2, i64 %i11
  %i13 = load i32, ptr %i12
  %i14 = add nsw i32 %i13, %i8
  store i32 %i14, ptr %i12
  %i15 = getelementptr inbounds i32, ptr %i7, i64 1
  %i16 = icmp eq ptr %i15, %arg1
  br i1 %i16, label %bb5, label %bb6

bb5:
  ret void
}

; During SCEV rewrites, we could end up calling `ScalarEvolution::getPtrToIntExpr()`
; on an integer. Make sure we handle that case gracefully.
define void @ptrtoint_of_integer(ptr %arg, i64 %arg1, i1 %arg2) local_unnamed_addr {
; X64-LABEL: 'ptrtoint_of_integer'
; X64-NEXT:  Classifying expressions for: @ptrtoint_of_integer
; X64-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X64-NEXT:    --> (ptrtoint ptr %arg to i64) U: full-set S: full-set
; X64-NEXT:    %i6 = sub i64 %i4, %arg1
; X64-NEXT:    --> ((-1 * %arg1) + (ptrtoint ptr %arg to i64)) U: full-set S: full-set
; X64-NEXT:    %i9 = phi i64 [ 1, %bb7 ], [ %i11, %bb10 ]
; X64-NEXT:    --> {1,+,1}<nuw><%bb8> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %bb8: Computable }
; X64-NEXT:    %i11 = add nuw i64 %i9, 1
; X64-NEXT:    --> {2,+,1}<nw><%bb8> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb8: Computable }
; X64-NEXT:  Determining loop execution counts for: @ptrtoint_of_integer
; X64-NEXT:  Loop %bb8: <multiple exits> Unpredictable backedge-taken count.
; X64-NEXT:    exit count for bb8: ***COULDNOTCOMPUTE***
; X64-NEXT:    exit count for bb10: (-2 + (-1 * %arg1) + (ptrtoint ptr %arg to i64))
; X64-NEXT:  Loop %bb8: constant max backedge-taken count is i64 -1
; X64-NEXT:  Loop %bb8: symbolic max backedge-taken count is (-2 + (-1 * %arg1) + (ptrtoint ptr %arg to i64))
; X64-NEXT:    symbolic max exit count for bb8: ***COULDNOTCOMPUTE***
; X64-NEXT:    symbolic max exit count for bb10: (-2 + (-1 * %arg1) + (ptrtoint ptr %arg to i64))
; X64-NEXT:  Loop %bb8: Unpredictable predicated backedge-taken count.
;
; X32-LABEL: 'ptrtoint_of_integer'
; X32-NEXT:  Classifying expressions for: @ptrtoint_of_integer
; X32-NEXT:    %i4 = ptrtoint ptr %arg to i64
; X32-NEXT:    --> (zext i32 (ptrtoint ptr %arg to i32) to i64) U: [0,4294967296) S: [0,4294967296)
; X32-NEXT:    %i6 = sub i64 %i4, %arg1
; X32-NEXT:    --> ((zext i32 (ptrtoint ptr %arg to i32) to i64) + (-1 * %arg1)) U: full-set S: full-set
; X32-NEXT:    %i9 = phi i64 [ 1, %bb7 ], [ %i11, %bb10 ]
; X32-NEXT:    --> {1,+,1}<nuw><%bb8> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %bb8: Computable }
; X32-NEXT:    %i11 = add nuw i64 %i9, 1
; X32-NEXT:    --> {2,+,1}<nw><%bb8> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %bb8: Computable }
; X32-NEXT:  Determining loop execution counts for: @ptrtoint_of_integer
; X32-NEXT:  Loop %bb8: <multiple exits> Unpredictable backedge-taken count.
; X32-NEXT:    exit count for bb8: ***COULDNOTCOMPUTE***
; X32-NEXT:    exit count for bb10: (-2 + (zext i32 (ptrtoint ptr %arg to i32) to i64) + (-1 * %arg1))
; X32-NEXT:  Loop %bb8: constant max backedge-taken count is i64 -1
; X32-NEXT:  Loop %bb8: symbolic max backedge-taken count is (-2 + (zext i32 (ptrtoint ptr %arg to i32) to i64) + (-1 * %arg1))
; X32-NEXT:    symbolic max exit count for bb8: ***COULDNOTCOMPUTE***
; X32-NEXT:    symbolic max exit count for bb10: (-2 + (zext i32 (ptrtoint ptr %arg to i32) to i64) + (-1 * %arg1))
; X32-NEXT:  Loop %bb8: Unpredictable predicated backedge-taken count.
;
bb:
  %i = icmp eq ptr %arg, null
  br i1 %i, label %bb14, label %bb3

bb3:                                              ; preds = %bb
  %i4 = ptrtoint ptr %arg to i64
  br label %bb5

bb5:                                              ; preds = %bb3
  %i6 = sub i64 %i4, %arg1
  br label %bb7

bb7:                                              ; preds = %bb5
  br label %bb8

bb8:                                              ; preds = %bb10, %bb7
  %i9 = phi i64 [ 1, %bb7 ], [ %i11, %bb10 ]
  br i1 %arg2, label %bb10, label %bb13

bb10:                                             ; preds = %bb8
  %i11 = add nuw i64 %i9, 1
  %i12 = icmp eq i64 %i11, %i6
  br i1 %i12, label %bb13, label %bb8

bb13:                                             ; preds = %bb10, %bb8
  ret void

bb14:                                             ; preds = %bb
  ret void
}
