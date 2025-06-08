#+private
package datatypes

import "core:testing"
import "core:fmt"

@(test)
run_test_queue :: proc(_: ^testing.T) {
    queue: Queue(int, 256)

    err_init := queue_init(&queue)
    assert(err_init == nil, "Error while initializing queue")

    err_push := queue_enqueue(&queue, 0)
    assert(err_push == nil, "Error while enqueing 0")
    err_push = queue_enqueue(&queue, 1)
    assert(err_push == nil, "Error while enqueing 1")
    err_push = queue_enqueue(&queue, 2)
    assert(err_push == nil, "Error while enqueing 2")
    err_push = queue_enqueue(&queue, 3)
    assert(err_push == nil, "Error while enqueing 3")

    queue_foreach_ptr(&queue, proc(element: ^int) { element ^+= 1 })

    val, err_pull := queue_dequeue(&queue)
    assert(err_pull == nil, "Error while pulling first element")
    assert(val == 1, "Element 0 is not expected value")
    val, err_pull = queue_dequeue(&queue)
    assert(err_pull == nil, "Error while pulling second element")
    assert(val == 2, "Element 1 is not expected value")
    val, err_pull = queue_dequeue(&queue)
    assert(err_pull == nil, "Error while pulling third element")
    assert(val == 3, "Element 2 is not expected value")
    val, err_pull = queue_dequeue(&queue)
    assert(err_pull == nil, "Error while pulling fourth element")
    assert(val == 4, "Element 3 is not expected value")

    assert(queue.count == 0, "Queue did not properly empty")
    assert(queue.write == queue.read, "Pointers not pointing to correct idx")

    for i in 0..=255 {
        err_push = queue_enqueue(&queue, i)
        assert(err_push == nil, "Error while pushin elements in loop")
    }

    queue_foreach_ptr(&queue, proc(element: ^int) { element ^+= 1 })

    for i in 0..=255 {
        val, err_pull = queue_dequeue(&queue)
        assert(err_pull == nil, "Error while pulling elements in loop")
        assert(val == i+1, "Pulled value does not queal expected value")
    }
}