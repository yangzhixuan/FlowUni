; ModuleID = 'ret.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

%struct.Ptr = type { %struct.Ptr2, i32*, i32 }
%struct.Ptr2 = type { i32* }

; Function Attrs: nounwind ssp uwtable
define i32* @f() #0 {
entry:
  %a = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata i32** %a, metadata !24, metadata !25), !dbg !26
  %call = call i8* @malloc(i64 4), !dbg !27
  %0 = bitcast i8* %call to i32*, !dbg !27
  store i32* %0, i32** %a, align 8, !dbg !26
  %1 = load i32*, i32** %a, align 8, !dbg !28
  ret i32* %1, !dbg !29
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64) #2

; Function Attrs: nounwind ssp uwtable
define void @g(%struct.Ptr* noalias sret %agg.result) #0 {
entry:
  %a = alloca i32*, align 8
  %p = alloca %struct.Ptr, align 8
  call void @llvm.dbg.declare(metadata i32** %a, metadata !30, metadata !25), !dbg !31
  %call = call i8* @malloc(i64 4), !dbg !32
  %0 = bitcast i8* %call to i32*, !dbg !32
  store i32* %0, i32** %a, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata %struct.Ptr* %p, metadata !33, metadata !25), !dbg !34
  %1 = load i32*, i32** %a, align 8, !dbg !35
  %p1 = getelementptr inbounds %struct.Ptr, %struct.Ptr* %p, i32 0, i32 1, !dbg !36
  store i32* %1, i32** %p1, align 8, !dbg !37
  %call2 = call i8* @malloc(i64 4), !dbg !38
  %2 = bitcast i8* %call2 to i32*, !dbg !38
  %s2 = getelementptr inbounds %struct.Ptr, %struct.Ptr* %p, i32 0, i32 0, !dbg !39
  %p2 = getelementptr inbounds %struct.Ptr2, %struct.Ptr2* %s2, i32 0, i32 0, !dbg !40
  store i32* %2, i32** %p2, align 8, !dbg !41
  %3 = bitcast %struct.Ptr* %agg.result to i8*, !dbg !42
  %4 = bitcast %struct.Ptr* %p to i8*, !dbg !42
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %3, i8* %4, i64 24, i32 8, i1 false), !dbg !42
  ret void, !dbg !43
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #3

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!20, !21, !22}
!llvm.ident = !{!23}

!0 = !MDCompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "ret.c", directory: "/Users/yangzx/llvm-dsa/projects/poolalloc/tools/leakplug/tests")
!2 = !{}
!3 = !{!4, !9}
!4 = !MDSubprogram(name: "f", scope: !1, file: !1, line: 1, type: !5, isLocal: false, isDefinition: true, scopeLine: 2, isOptimized: false, function: i32* ()* @f, variables: !2)
!5 = !MDSubroutineType(types: !6)
!6 = !{!7}
!7 = !MDDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64, align: 64)
!8 = !MDBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !MDSubprogram(name: "g", scope: !1, file: !1, line: 14, type: !10, isLocal: false, isDefinition: true, scopeLine: 15, isOptimized: false, function: void (%struct.Ptr*)* @g, variables: !2)
!10 = !MDSubroutineType(types: !11)
!11 = !{!12}
!12 = !MDCompositeType(tag: DW_TAG_structure_type, name: "Ptr", file: !1, line: 7, size: 192, align: 64, elements: !13)
!13 = !{!14, !18, !19}
!14 = !MDDerivedType(tag: DW_TAG_member, name: "s2", scope: !12, file: !1, line: 10, baseType: !15, size: 64, align: 64)
!15 = !MDCompositeType(tag: DW_TAG_structure_type, name: "Ptr2", file: !1, line: 8, size: 64, align: 64, elements: !16)
!16 = !{!17}
!17 = !MDDerivedType(tag: DW_TAG_member, name: "p2", scope: !15, file: !1, line: 9, baseType: !7, size: 64, align: 64)
!18 = !MDDerivedType(tag: DW_TAG_member, name: "p", scope: !12, file: !1, line: 11, baseType: !7, size: 64, align: 64, offset: 64)
!19 = !MDDerivedType(tag: DW_TAG_member, name: "x", scope: !12, file: !1, line: 12, baseType: !8, size: 32, align: 32, offset: 128)
!20 = !{i32 2, !"Dwarf Version", i32 2}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"PIC Level", i32 2}
!23 = !{!"clang version 3.7.0 (trunk) (https://github.com/jtcriswell/llvm-dsa.git ad8a7d5819f35463224c483b3e1a62dc1cbcf966)"}
!24 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a", scope: !4, file: !1, line: 3, type: !7)
!25 = !MDExpression()
!26 = !MDLocation(line: 3, column: 8, scope: !4)
!27 = !MDLocation(line: 3, column: 12, scope: !4)
!28 = !MDLocation(line: 4, column: 10, scope: !4)
!29 = !MDLocation(line: 4, column: 3, scope: !4)
!30 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "a", scope: !9, file: !1, line: 16, type: !7)
!31 = !MDLocation(line: 16, column: 8, scope: !9)
!32 = !MDLocation(line: 16, column: 12, scope: !9)
!33 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "p", scope: !9, file: !1, line: 17, type: !12)
!34 = !MDLocation(line: 17, column: 14, scope: !9)
!35 = !MDLocation(line: 18, column: 9, scope: !9)
!36 = !MDLocation(line: 18, column: 5, scope: !9)
!37 = !MDLocation(line: 18, column: 7, scope: !9)
!38 = !MDLocation(line: 19, column: 13, scope: !9)
!39 = !MDLocation(line: 19, column: 5, scope: !9)
!40 = !MDLocation(line: 19, column: 8, scope: !9)
!41 = !MDLocation(line: 19, column: 11, scope: !9)
!42 = !MDLocation(line: 20, column: 10, scope: !9)
!43 = !MDLocation(line: 20, column: 3, scope: !9)
