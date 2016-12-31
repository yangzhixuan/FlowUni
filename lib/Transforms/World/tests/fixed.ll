; ModuleID = 'fixed.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; Function Attrs: nounwind ssp uwtable
define void @f(i8* %b, i32 %c) #0 !dbg !4 {
entry:
  call void @llvm.dbg.value(metadata i8* %b, i64 0, metadata !14, metadata !15), !dbg !16
  call void @llvm.dbg.value(metadata i32 %c, i64 0, metadata !17, metadata !15), !dbg !18
  %call = call i8* @malloc(i64 1), !dbg !19
  call void @llvm.dbg.value(metadata i8* %call, i64 0, metadata !20, metadata !15), !dbg !21
  %cmp = icmp eq i8* %b, %call, !dbg !22
  br i1 %cmp, label %if.then, label %if.end, !dbg !24

if.then:                                          ; preds = %entry
  tail call void @free(i8* %call)
  br label %return, !dbg !25

if.end:                                           ; preds = %entry
  call void @llvm.dbg.value(metadata i8* %call, i64 0, metadata !14, metadata !15), !dbg !16
  call void @free(i8* %call), !dbg !27
  br label %return, !dbg !28

return:                                           ; preds = %if.end, %if.then
  ret void, !dbg !29
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64) #2

declare void @free(i8*) #2

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !DIFile(filename: "canfix.c", directory: "/Users/yangzx/llvm-dsa/lib/Transforms/World/tests")
!2 = !{}
!3 = !{!4}
!4 = distinct !DISubprogram(name: "f", scope: !1, file: !1, line: 3, type: !5, isLocal: false, isDefinition: true, scopeLine: 3, flags: DIFlagPrototyped, isOptimized: false, variables: !2)
!5 = !DISubroutineType(types: !6)
!6 = !{null, !7, !9}
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64, align: 64)
!8 = !DIBasicType(name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!9 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!10 = !{i32 2, !"Dwarf Version", i32 2}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"PIC Level", i32 2}
!13 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!14 = !DILocalVariable(name: "b", arg: 1, scope: !4, file: !1, line: 3, type: !7)
!15 = !DIExpression()
!16 = !DILocation(line: 3, column: 14, scope: !4)
!17 = !DILocalVariable(name: "c", arg: 2, scope: !4, file: !1, line: 3, type: !9)
!18 = !DILocation(line: 3, column: 21, scope: !4)
!19 = !DILocation(line: 4, column: 15, scope: !4)
!20 = !DILocalVariable(name: "a", scope: !4, file: !1, line: 4, type: !7)
!21 = !DILocation(line: 4, column: 11, scope: !4)
!22 = !DILocation(line: 5, column: 10, scope: !23)
!23 = distinct !DILexicalBlock(scope: !4, file: !1, line: 5, column: 8)
!24 = !DILocation(line: 5, column: 8, scope: !4)
!25 = !DILocation(line: 6, column: 9, scope: !26)
!26 = distinct !DILexicalBlock(scope: !23, file: !1, line: 5, column: 16)
!27 = !DILocation(line: 9, column: 5, scope: !4)
!28 = !DILocation(line: 10, column: 5, scope: !4)
!29 = !DILocation(line: 11, column: 1, scope: !4)
