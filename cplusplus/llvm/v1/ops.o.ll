; ModuleID = 'ops.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i386-apple-darwin9.5.0"

@.str = internal constant [7 x i8] c"=> %d\0A\00" ; <[7 x i8]*> [#uses=1]

define void @add(i32* %registers, i32* %ops) nounwind {
entry:
  %tmp1 = getelementptr i32* %ops, i32 1          ; <i32*> [#uses=1]
  %tmp2 = load i32* %tmp1, align 4                ; <i32> [#uses=1]
  %tmp4 = getelementptr i32* %ops, i32 2          ; <i32*> [#uses=1]
  %tmp5 = load i32* %tmp4, align 4                ; <i32> [#uses=1]
  %tmp7 = getelementptr i32* %registers, i32 %tmp5 ; <i32*> [#uses=1]
  %tmp8 = load i32* %tmp7, align 4                ; <i32> [#uses=1]
  %tmp10 = getelementptr i32* %ops, i32 3         ; <i32*> [#uses=1]
  %tmp11 = load i32* %tmp10, align 4              ; <i32> [#uses=1]
  %tmp12 = add i32 %tmp11, %tmp8                  ; <i32> [#uses=1]
  %tmp14 = getelementptr i32* %registers, i32 %tmp2 ; <i32*> [#uses=1]
  store i32 %tmp12, i32* %tmp14, align 4
  ret void
}

define void @set(i32* %registers, i32* %ops) nounwind {
entry:
  %tmp1 = getelementptr i32* %ops, i32 1          ; <i32*> [#uses=1]
  %tmp2 = load i32* %tmp1, align 4                ; <i32> [#uses=1]
  %tmp4 = getelementptr i32* %ops, i32 2          ; <i32*> [#uses=1]
  %tmp5 = load i32* %tmp4, align 4                ; <i32> [#uses=1]
  %tmp7 = getelementptr i32* %registers, i32 %tmp2 ; <i32*> [#uses=1]
  store i32 %tmp5, i32* %tmp7, align 4
  ret void
}

define void @show(i32* %registers, i32* %ops) nounwind {
entry:
  %tmp1 = getelementptr i32* %ops, i32 1          ; <i32*> [#uses=1]
  %tmp2 = load i32* %tmp1, align 4                ; <i32> [#uses=1]
  %tmp4 = getelementptr i32* %registers, i32 %tmp2 ; <i32*> [#uses=1]
  %tmp5 = load i32* %tmp4, align 4                ; <i32> [#uses=1]
  %tmp6 = tail call i32 (i8*, ...)* @printf(i8* noalias getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0), i32 %tmp5) nounwind ; <i32> [#uses=0]
  ret void
}

declare i32 @printf(i8*, ...) nounwind

define void @main(i32* %registers, i32* %ops) {
entry:
	call void @set( i32* %registers, i32* %ops )
	%tmp = getelementptr i32* %ops, i32 3		; <i32*> [#uses=2]
	call void @show( i32* %registers, i32* %tmp )
	%tmp1 = getelementptr i32* %tmp, i32 2		; <i32*> [#uses=2]
	call void @add( i32* %registers, i32* %tmp1 )
	%tmp2 = getelementptr i32* %tmp1, i32 4		; <i32*> [#uses=2]
	call void @show( i32* %registers, i32* %tmp2 )
	%tmp3 = getelementptr i32* %tmp2, i32 2		; <i32*> [#uses=2]
	call void @add( i32* %registers, i32* %tmp3 )
	%tmp4 = getelementptr i32* %tmp3, i32 4		; <i32*> [#uses=1]
	call void @show( i32* %registers, i32* %tmp4 )
	ret void
}
