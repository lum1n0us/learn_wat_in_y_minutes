(module
  ;; function types list
  ;; used by import, call_indirect
  ;; generated automatically ?
  (type $t0 (func (param i32) (result i32)))
  (type $t1 (func (param i32 i64) (result f32)))
  (type $t2 (func (result i32)))

  ;; import functions from outside, module name + function name
  ;; (import "env" "puts" (func $puts (param i32) (result i32)))
  (import "env" "puts" (func $puts (type 0)))
  ;; improt global
  (import "env" "globals" (global $g1 (mut i32)))
  ;; import table
  ;;(import "env" "table")
  ;; import memory
  ;;(import "env" "memory")

  ;; it is a funciton without any argument and always return 42
  ;; result is a keyword
  (func (type $t2) (result i32)
    (i32.const 42)
    return
  )

  ;; 2 arguments and a return
  (func (type $t1) (param i32) (param i64) (result f32)
    ;; local.get will push the value to the stack
    ;; local.get 0 will get the first param i32
    ;; local.set will pop the value from the stack
    local.get 0
    ;; call inside with its index or name
    ;; its return value is on the stack
    call 0

    local.get 0
    f32.const 3.14
    ;; call inside with its index or name
    ;; its return value is on the stack
    call $f2

    ;; local.get 1 will get the second param i64
    local.get 1
    i64.add

    (f32.const 3.14)
    return
  )

  ;; the text format allow to name parameters, locals and
  ;; most other items by including a name prefixed by
  ;; a dollor symbol, like $p, $local, $name.
  ;; Note that when those text($name) get converted
  ;; to binary, the binary will only contain the integer
  (func $f2 (param $p1 i32) (param $p2 f32) (result i64)
    (local $l1 i32)
    (local $l2 f32)
    ;; $l1 = $p1
    ;; $l2 = $p2
    local.get $p1
    local.set $l1
    local.get $p2
    local.set $l2

    ;; (i32)($l2) + $l1
    local.get $l2
    i32.trunc_f32_s
    local.get $l1
    i32.add

    ;; cast i32 to i64
    i64.extend_i32_s
    return
  )

  ;; use call_indirect to call a function in a table
  ;; the index of the function in a table is 1
  (func $f3 (param $p1 i32) (result i32)
    (call_indirect (type 0)
      ;; callee param
      (local.get 0)
      ;; #1 elem in the table
      (i32.const 1)
    )
    return
  )

  ;; call ith function in a table
  ;; export it as "callByIndex"
  (func (export "callByIndex") (param $i i32) (result i32)
    (call_indirect (type 1)
      (i32.const 10)
      (i64.const 100)
      ;; index from param
      (local.get $i)
    )
    i32.trunc_f32_s
    return
  )

  ;; declare a table with 2 elements(initial size is 2)
  ;; maximum size is 2.
  ;; funcref is the element type.
  (table 3 3 funcref)
  ;; elem section lists any subset of the functions in a
  ;; module, in any order, allowing duplicates
  ;; (i32.const 1) specifies at what index in the table
  ;; references start to be populated.
  (elem 0 (i32.const 1) 1 $f2 $f3)

  ;; export $f3
  (export "function_3" (func $f3))
)
