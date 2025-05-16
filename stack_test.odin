package datatypes

import "core:testing"
import "core:fmt"

@(test)
run_test_stack :: proc(_: ^testing.T) {
    stack: Stack(int, 5)

    errInit := stack_init(&stack)
    assert(errInit == nil, "Error while initializing Stacl")

    size, errCount := stack_count(&stack)
    assert(errCount == nil, "Error while getting Size")
    assert(size == 0, "Size after Initializaion does not match expected size 0")

    for i := 0; i < 5; i += 1 {
        errPush := stack_push(&stack, i)
        assert(errPush == nil, "Error while pushing to stack")
    } 

    size2, errCount2 := stack_count(&stack)
    assert(errCount2 == nil, "Error while getting Size")
    assert(size2 == 5, "Size after Fill does not match expected size 5")

    for i := 4; i >= 0; i -= 1 {
        val, errPop := stack_pop(&stack)
        assert(errPop == nil, "Error while popping from stack")
        assert(val == i, "Values did not match up")
    
        size3, errCount3 := stack_count(&stack)
        //fmt.printfln("Size: %i = 5 - %i = %i", size3, i, 5-i)
        assert(errCount3 == nil, "Error while getting Size")
        assert(size3 == i, "Size after Popping does not match expected size")
    }

    for i := 0; i < 5; i += 1 {
        errPush := stack_push(&stack, i)
        assert(errPush == nil, "Error while pushing to stack, 2. Fill Operation")
    }

    errClear := stack_clear(&stack)
    assert(errClear == nil, "Error while clearing Stack")

    size4, errCount4 := stack_count(&stack)
    assert(errCount4 == nil, "Error while getting Size")
    assert(size4 == 0, "Size after Clearing does not match expected size 0")

    errDestr := stack_destroy(&stack)
    assert(errDestr == nil, "Error while destroying stack")
}