; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -disable-output "-passes=print<scalar-evolution>" -S < %s 2>&1 | FileCheck %s

define i16 @test1(i8 %x) {
; CHECK-LABEL: 'test1'
; CHECK-NEXT:  Classifying expressions for: @test1
; CHECK-NEXT:    %A = zext i8 %x to i12
; CHECK-NEXT:    --> (zext i8 %x to i12) U: [0,256) S: [0,256)
; CHECK-NEXT:    %B = sext i12 %A to i16
; CHECK-NEXT:    --> (zext i8 %x to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:  Determining loop execution counts for: @test1
;
  %A = zext i8 %x to i12
  %B = sext i12 %A to i16
  ret i16 %B
}

define i8 @test2(i8 %x) {
; CHECK-LABEL: 'test2'
; CHECK-NEXT:  Classifying expressions for: @test2
; CHECK-NEXT:    %A = zext i8 %x to i16
; CHECK-NEXT:    --> (zext i8 %x to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:    %B = add i16 %A, 1025
; CHECK-NEXT:    --> (1025 + (zext i8 %x to i16))<nuw><nsw> U: [1025,1281) S: [1025,1281)
; CHECK-NEXT:    %C = trunc i16 %B to i8
; CHECK-NEXT:    --> (1 + %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @test2
;
  %A = zext i8 %x to i16
  %B = add i16 %A, 1025
  %C = trunc i16 %B to i8
  ret i8 %C
}

define i8 @test3(i8 %x) {
; CHECK-LABEL: 'test3'
; CHECK-NEXT:  Classifying expressions for: @test3
; CHECK-NEXT:    %A = zext i8 %x to i16
; CHECK-NEXT:    --> (zext i8 %x to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:    %B = mul i16 %A, 1027
; CHECK-NEXT:    --> (1027 * (zext i8 %x to i16)) U: full-set S: full-set
; CHECK-NEXT:    %C = trunc i16 %B to i8
; CHECK-NEXT:    --> (3 * %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @test3
;
  %A = zext i8 %x to i16
  %B = mul i16 %A, 1027
  %C = trunc i16 %B to i8
  ret i8 %C
}

define void @test4(i32 %x, i32 %y) {
; CHECK-LABEL: 'test4'
; CHECK-NEXT:  Classifying expressions for: @test4
; CHECK-NEXT:    %Y = and i32 %y, 3
; CHECK-NEXT:    --> (zext i2 (trunc i32 %y to i2) to i32) U: [0,4) S: [0,4)
; CHECK-NEXT:    %A = phi i32 [ 0, %entry ], [ %I, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %Z1 = select i1 %rand1, i32 %A, i32 %Y
; CHECK-NEXT:    --> ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %Z2 = select i1 %rand2, i32 %A, i32 %Z1
; CHECK-NEXT:    --> ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %B = trunc i32 %Z2 to i16
; CHECK-NEXT:    --> (trunc i32 ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) to i16) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %C = sext i16 %B to i30
; CHECK-NEXT:    --> (trunc i32 ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) to i30) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %D = sext i16 %B to i32
; CHECK-NEXT:    --> ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %E = sext i16 %B to i34
; CHECK-NEXT:    --> ((zext i32 ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>) to i34) umax {0,+,1}<nuw><nsw><%loop>) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %F = zext i16 %B to i30
; CHECK-NEXT:    --> (trunc i32 ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) to i30) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %G = zext i16 %B to i32
; CHECK-NEXT:    --> ({0,+,1}<nuw><nsw><%loop> umax ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>)) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %H = zext i16 %B to i34
; CHECK-NEXT:    --> ((zext i32 ((zext i2 (trunc i32 %y to i2) to i32) smax {0,+,1}<nuw><nsw><%loop>) to i34) umax {0,+,1}<nuw><nsw><%loop>) U: [0,21) S: [0,21) Exits: 20 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %I = add i32 %A, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,22) S: [1,22) Exits: 21 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @test4
; CHECK-NEXT:  Loop %loop: backedge-taken count is 20
; CHECK-NEXT:  Loop %loop: constant max backedge-taken count is i32 20
; CHECK-NEXT:  Loop %loop: symbolic max backedge-taken count is 20
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is 20
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %loop: Trip multiple is 21
;
entry:
  %Y = and i32 %y, 3
  br label %loop
loop:
  %A = phi i32 [0, %entry], [%I, %loop]
  %rand1 = icmp sgt i32 %A, %Y
  %Z1 = select i1 %rand1, i32 %A, i32 %Y
  %rand2 = icmp ugt i32 %A, %Z1
  %Z2 = select i1 %rand2, i32 %A, i32 %Z1
  %B = trunc i32 %Z2 to i16
  %C = sext i16 %B to i30
  %D = sext i16 %B to i32
  %E = sext i16 %B to i34
  %F = zext i16 %B to i30
  %G = zext i16 %B to i32
  %H = zext i16 %B to i34
  %I = add i32 %A, 1
  %0 = icmp ne i32 %A, 20
  br i1 %0, label %loop, label %exit
exit:
  ret void
}

define void @test5(i32 %i) {
; CHECK-LABEL: 'test5'
; CHECK-NEXT:  Classifying expressions for: @test5
; CHECK-NEXT:    %A = and i32 %i, 1
; CHECK-NEXT:    --> (zext i1 (trunc i32 %i to i1) to i32) U: [0,2) S: [0,2)
; CHECK-NEXT:    %B = and i32 %i, 2
; CHECK-NEXT:    --> (2 * (zext i1 (trunc i32 (%i /u 2) to i1) to i32))<nuw><nsw> U: [0,3) S: [0,3)
; CHECK-NEXT:    %C = and i32 %i, 63
; CHECK-NEXT:    --> (zext i6 (trunc i32 %i to i6) to i32) U: [0,64) S: [0,64)
; CHECK-NEXT:    %D = and i32 %i, 126
; CHECK-NEXT:    --> (2 * (zext i6 (trunc i32 (%i /u 2) to i6) to i32))<nuw><nsw> U: [0,127) S: [0,127)
; CHECK-NEXT:    %E = and i32 %i, 64
; CHECK-NEXT:    --> (64 * (zext i1 (trunc i32 (%i /u 64) to i1) to i32))<nuw><nsw> U: [0,65) S: [0,65)
; CHECK-NEXT:    %F = and i32 %i, -2147483648
; CHECK-NEXT:    --> (-2147483648 * (%i /u -2147483648))<nuw><nsw> U: [0,-2147483647) S: [-2147483648,1)
; CHECK-NEXT:  Determining loop execution counts for: @test5
;
  %A = and i32 %i, 1
  %B = and i32 %i, 2
  %C = and i32 %i, 63
  %D = and i32 %i, 126
  %E = and i32 %i, 64
  %F = and i32 %i, -2147483648
  ret void
}

define void @test6(i8 %x) {
; CHECK-LABEL: 'test6'
; CHECK-NEXT:  Classifying expressions for: @test6
; CHECK-NEXT:    %A = zext i8 %x to i16
; CHECK-NEXT:    --> (zext i8 %x to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:    %B = shl nuw i16 %A, 8
; CHECK-NEXT:    --> (256 * (zext i8 %x to i16))<nuw> U: [0,-255) S: [-32768,32513)
; CHECK-NEXT:    %C = and i16 %B, -2048
; CHECK-NEXT:    --> (2048 * ((zext i8 %x to i16) /u 8))<nuw> U: [0,-2047) S: [-32768,30721)
; CHECK-NEXT:  Determining loop execution counts for: @test6
;
  %A = zext i8 %x to i16
  %B = shl nuw i16 %A, 8
  %C = and i16 %B, -2048
  ret void
}

; PR22960
define void @test7(i32 %A) {
; CHECK-LABEL: 'test7'
; CHECK-NEXT:  Classifying expressions for: @test7
; CHECK-NEXT:    %B = sext i32 %A to i64
; CHECK-NEXT:    --> (sext i32 %A to i64) U: [-2147483648,2147483648) S: [-2147483648,2147483648)
; CHECK-NEXT:    %C = zext i32 %A to i64
; CHECK-NEXT:    --> (zext i32 %A to i64) U: [0,4294967296) S: [0,4294967296)
; CHECK-NEXT:    %D = sub i64 %B, %C
; CHECK-NEXT:    --> ((sext i32 %A to i64) + (-1 * (zext i32 %A to i64))<nsw>) U: [-6442450943,2147483648) S: [-6442450943,2147483648)
; CHECK-NEXT:    %E = trunc i64 %D to i16
; CHECK-NEXT:    --> 0 U: [0,1) S: [0,1)
; CHECK-NEXT:  Determining loop execution counts for: @test7
;
  %B = sext i32 %A to i64
  %C = zext i32 %A to i64
  %D = sub i64 %B, %C
  %E = trunc i64 %D to i16
  ret void
}

define i64 @test8(i64 %a) {
; CHECK-LABEL: 'test8'
; CHECK-NEXT:  Classifying expressions for: @test8
; CHECK-NEXT:    %t0 = udiv i64 %a, 56
; CHECK-NEXT:    --> (%a /u 56) U: [0,329406144173384851) S: [0,329406144173384851)
; CHECK-NEXT:    %t1 = udiv i64 %t0, 56
; CHECK-NEXT:    --> (%a /u 3136) U: [0,5882252574524730) S: [0,5882252574524730)
; CHECK-NEXT:  Determining loop execution counts for: @test8
;
  %t0 = udiv i64 %a, 56
  %t1 = udiv i64 %t0, 56
  ret i64 %t1
}

define i64 @test9(i64 %a) {
; CHECK-LABEL: 'test9'
; CHECK-NEXT:  Classifying expressions for: @test9
; CHECK-NEXT:    %t0 = udiv i64 %a, 100000000000000
; CHECK-NEXT:    --> (%a /u 100000000000000) U: [0,184468) S: [0,184468)
; CHECK-NEXT:    %t1 = udiv i64 %t0, 100000000000000
; CHECK-NEXT:    --> 0 U: [0,1) S: [0,1)
; CHECK-NEXT:  Determining loop execution counts for: @test9
;
  %t0 = udiv i64 %a, 100000000000000
  %t1 = udiv i64 %t0, 100000000000000
  ret i64 %t1
}

define i64 @test10(i64 %a, i64 %b) {
; CHECK-LABEL: 'test10'
; CHECK-NEXT:  Classifying expressions for: @test10
; CHECK-NEXT:    %t0 = udiv i64 %a, 100000000000000
; CHECK-NEXT:    --> (%a /u 100000000000000) U: [0,184468) S: [0,184468)
; CHECK-NEXT:    %t1 = udiv i64 %t0, 100000000000000
; CHECK-NEXT:    --> 0 U: [0,1) S: [0,1)
; CHECK-NEXT:    %t2 = mul i64 %b, %t1
; CHECK-NEXT:    --> 0 U: [0,1) S: [0,1)
; CHECK-NEXT:  Determining loop execution counts for: @test10
;
  %t0 = udiv i64 %a, 100000000000000
  %t1 = udiv i64 %t0, 100000000000000
  %t2 = mul i64 %b, %t1
  ret i64 %t2
}

define i64 @test11(i64 %a) {
; CHECK-LABEL: 'test11'
; CHECK-NEXT:  Classifying expressions for: @test11
; CHECK-NEXT:    %t0 = udiv i64 0, %a
; CHECK-NEXT:    --> 0 U: [0,1) S: [0,1)
; CHECK-NEXT:  Determining loop execution counts for: @test11
;
  %t0 = udiv i64 0, %a
  ret i64 %t0
}
