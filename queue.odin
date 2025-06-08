package datatypes

/**
A Queue implementation using a circular buffer with a preset size
*/
Queue :: struct($T: typeid, $cap: int) {
    ring: [cap]T,
    read, write, count: u32,
    isInitialized: bool
}

queue_init :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return .Queue_Cannot_Be_Nil 
    if self.isInitialized do return .Queue_Already_Initialized

    self.read = 0
    self.write = 0
    self.count = 0
    self.isInitialized = true
    return nil
}

queue_destroy :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return .Queue_Cannot_Be_Nil
    if !self.isInitialized do return .Queue_Not_Initialized

    //Noop, but still implemented for completeness-sake
    return nil
}

queue_count :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> (count: int, err: Error) {
    if self == nil do return 0, .Queue_Cannot_Be_Nil
    if !self.isInitialized do return 0, .Queue_Not_Initialized

    //Noop, but still implemented for completeness-sake
    return self.count, nil
}

queue_len :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> (len: int, err: Error) {
    if self == nil do return 0, .Queue_Cannot_Be_Nil
    if !self.isInitialized do return 0, .Queue_Not_Initialized

    //Noop, but still implemented for completeness-sake
    return cap, nil
}

queue_clear :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return .Queue_Cannot_Be_Nil
    if !self.isInitialized do return .Queue_Not_Initialized

    self.count = 0
    self.read = self.write

    return nil
}

queue_enqueue :: proc(
    self: ^Queue($T, $cap),
    element: T,
    loc := #caller_location
) -> Error {
    if self == nil do return .Queue_Cannot_Be_Nil
    if !self.isInitialized do return .Queue_Not_Initialized
    if self.write == self.read && self.count > 0 do return .Queue_Is_Full

    self.ring[self.write] = element
    self.write += 1
    if self.write >= u32(cap) do self.write = 0

    self.count += 1
    return nil
}

queue_dequeue :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> (val: T, err: Error) {
    if self == nil do return {}, .Queue_Cannot_Be_Nil
    if !self.isInitialized do return {}, .Queue_Not_Initialized
    if self.write == self.read && self.count == 0 do return {}, nil
    
    retVal := self.ring[self.read]
    self.read += 1
    if self.read >= u32(cap) do self.read = 0
    
    self.count -= 1

    return retVal, nil
}

queue_dequeue_ptr :: proc(
    self: ^Queue($T, $cap),
    loc := #caller_location
) -> (val: ^T, err: Error) {
    if self == nil do return {}, .Queue_Cannot_Be_Nil
    if !self.isInitialized do return {}, .Queue_Not_Initialized
    if self.write == self.read && self.count == 0 do return {}, nil
    
    retVal := &self.ring[self.read]
    self.read += 1
    if self.read >= cap do self.read == 0
    
    self.count -= 1

    return retVal, nil
}

queue_foreach :: proc(
    self: ^Queue($T, $cap),
    func: proc(T),
    loc := #caller_location
) {
    elementIndex := self.read
    for i : u32 = 0; i < self.count; i += 1 {
        func(self.ring[elementIndex])
        elementIndex += 1
        if elementIndex >= u32(cap) do elementIndex = 0
    }
}

queue_foreach_ptr :: proc(
    self: ^Queue($T, $cap),
    func: proc(^T),
    loc := #caller_location
) {
    elementIndex := self.read
    for i : u32 = 0; i < self.count; i += 1 {
        func(&self.ring[elementIndex])
        elementIndex += 1
        if elementIndex >= u32(cap) do elementIndex = 0
    }
}

QueueError :: enum {
    Queue_Cannot_Be_Nil,
    Queue_Already_Initialized,
    Queue_Not_Initialized,
    Queue_Is_Full,
}