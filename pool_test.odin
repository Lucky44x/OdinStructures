#+private
package datatypes

import "core:testing"
import "core:fmt"

currentNum: int = 0

@(test)
run_test_pool :: proc(_: ^testing.T) {
    pool: Pool(int, 2)

    err_init := pool_init(&pool, 2, build, destructor)
    assert(err_init == nil, "Error while initializing pool")

    val, err_pop := pool_pop(&pool)
    fmt.printfln("Popped: %i", val)
    assert(err_pop == nil, "Error while popping from pool 1:1")
    assert(val == 1, "Popped value does not match expected value 1:1")

    val2, err_pop2 := pool_pop(&pool)
    fmt.printfln("Popped: %i", val2)
    assert(err_pop2 == nil, "Error while popping from pool 1:2")
    assert(val2 == 0, "Popped value does not match expected value 1:2")

    err_push := pool_push(&pool, val)
    assert(err_push == nil, "Error during push to pool")
    err_push = pool_push(&pool, val2)
    assert(err_push == nil, "Error during second push to pool")
    err_push = pool_push(&pool, 3)
    assert(err_push == nil, "Error during third push (destr)")

    val, err_pop = pool_pop(&pool)
    assert(err_pop == nil, "Error while popping from pool 2:1")
    assert(val == 0, "Popped value does not match expected value 2:1")

    val, err_pop = pool_pop(&pool)
    assert(err_pop == nil, "Error while popping from pool 2:2")
    assert(val == 1, "Popped value does not match expected value 2:2")

    err_clr := pool_clear(&pool)
    assert(err_clr == nil, "Error while clearing pool")
    
    cnt, err_cnt := pool_size(&pool)
    assert(err_cnt == nil, "Error while getting size of pool")
    assert(cnt == 0, "Size of Pool is not equal to expected size 0")

    err_dstr := pool_destroy(&pool)
    assert(err_dstr == nil, "Error while destroying pool")
}

build :: proc() -> int {
    oldNum := currentNum
    currentNum += 1
    return oldNum
}

destructor :: proc(d: int) {
    fmt.printfln("Destroying number %i", d)
}