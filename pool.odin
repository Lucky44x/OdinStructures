package datatypes

Pool :: struct($T: typeid, $cap: int) {
    stack: Stack(T, cap),
    builder: proc() -> (n: T),
    destructor: proc(n: T),
    isInitialized: bool
}

pool_init :: proc(
    self: ^Pool($T, $cap),
    startSize: int,
    builder: proc() -> (n: T),
    destructor: proc(n: T)
) -> Error {
    if self == nil do return PoolError.Pool_Cannot_Be_Nil
    
    maxSize := len(self.stack.items)
    if maxSize <= 0 do return PoolError.Pool_Cap_Should_Be_Greater_Than_Zero
    if maxSize < startSize do return PoolError.Pool_Cap_Should_Be_Larger_Than_Initial_Allocation_Value

    stack_init(&self.stack)
    
    self.builder = builder
    self.destructor = destructor

    for i in 0..<startSize do stack_push(&self.stack, #force_inline self.builder())

    self.isInitialized = true

    return nil
}

/*
Pushes the given value into the pool, and if the pool is full, will call the pool's destructor on it
*/
pool_push :: proc(
    self: ^Pool($T, $cap),
    value: T
) -> Error {
    if self == nil do return PoolError.Pool_Cannot_Be_Nil
    if !self.isInitialized do return PoolError.Pool_Not_Initialized

    //If Pool is already filled to it's max, destroy the value
    if stack_is_full(&self.stack) {
        #force_inline self.destructor(value)
        return nil
    }

    stack_push(&self.stack, value)
    return nil
}

/*
Pops the top value inside the pool, and if empty, creates a new value and returns it
*/
pool_pop :: proc(
    self: ^Pool($T, $cap)
) -> (val: T, err: Error) {
    if self == nil do return {}, PoolError.Pool_Cannot_Be_Nil
    if !self.isInitialized do return {}, PoolError.Pool_Not_Initialized

    //If empty, push a new value (<= will propably never happen, since the pool cannot have negative count of elements, but better safe than sorry, right?)
    if self.count <= 0 do #force_inline pool_push(self, self.builder())

    //Get "top" value in pool and return it
    return stack_pop(&self.stack)
}

/*
Clears the pool by destroying every of it's values
*/
pool_clear :: proc(
    self: ^Pool($T, $cap)
) -> Error {
    if self == nil do return PoolError.Pool_Cannot_Be_Nil
    if !self.isInitialized do return PoolError.Pool_Not_Initialized

    stackSize, _ := stack_count(&self.stack)
    for element in 0..<stackSize {
        element, _ := #force_inline stack_pop(&self.stack)
        #force_inline self.destructor(element)
    }

    stack_clear(&self.stack)
    return nil
}

/*
Destroys the Pool and all it's values
*/
pool_destroy :: proc(
    self: ^Pool($T, $cap)
) -> Error {
    if self == nil do return PoolError.Pool_Cannot_Be_Nil
    if !self.isInitialized do return PoolError.Pool_Not_Initialized

    //if pool is not empty, clear it (we can ignore the returned error, since we are already handling those cases)
    if self.count > 0 do #force_inline pool_clear(self)

    #force_inline delete(self.values)
    self.values = nil
    self.isInitialized = false
    
    return nil
}

PoolError :: enum {
    None = 0,
    Pool_Cannot_Be_Nil,
    Pool_Not_Initialized,
    Pool_Cap_Should_Be_Greater_Than_Zero,
    Pool_Cap_Should_Be_Larger_Than_Initial_Allocation_Value
}