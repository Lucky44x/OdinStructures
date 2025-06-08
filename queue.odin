package datatypes

/**
A Queue implementation using a circular buffer with a preset size
*/
Queue :: struct($T: typeid, $cap: int) {
    ring: [cap]T,
    read: u32,
    write: u32
}

queue_init :: proc(
    self: ^Queue,
    loc := #caller_location
) {
    
}