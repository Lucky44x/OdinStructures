package datatypes

Pool :: struct($T: typeid, $cap: int) {
    stack: Stack(T, cap),
    builder: proc() -> (n: T),
    destructor: proc(n: T),
    isInitialized: bool
}

/*
TODO: FIX ALL THIS SHIT
*/

pool_init :: proc(
    self: ^Pool($T, $cap),
    startSize: int,
    builder: proc() -> (n: T),
    destructor: proc(n: T)
) -> Error {
    if self == nil do return PoolError.Pool_Cannot_Be_Nil

    init_err := stack_init(&self.stack)
    if init_err != nil do return init_err

    maxSize, err := stack_len(&self.stack)
    if maxSize <= 0 do return PoolError.Pool_Cap_Should_Be_Greater_Than_Zero
    if maxSize < startSize do return PoolError.Pool_Cap_Should_Be_Larger_Than_Initial_Allocation_Value
    
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
    isStackFull, err := #force_inline stack_is_full(&self.stack)
    if  isStackFull {
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
    isStackEmpty, errEmpty := #force_inline stack_is_empty(&self.stack)
    if errEmpty != nil do return {}, errEmpty

    if isStackEmpty do #force_inline pool_push(self, self.builder())

    //Get "top" value in pool and return it
    popVal, errPop := stack_pop(&self.stack)
    if errPop != nil do return {}, err

    return popVal, nil
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
    isEmpty, _ := stack_is_empty(&self.stack)
    if !isEmpty do #force_inline pool_clear(self)

    self.isInitialized = false
    err := stack_destroy(&self.stack)
    return err
}

/*
Returns the count of elements inside this pool
*/
pool_size :: proc(
    self: ^Pool($T, $cap)
) -> (n: int, err: Error) {
    if self == nil do return 0, PoolError.Pool_Cannot_Be_Nil
    if !self.isInitialized do return 0, PoolError.Pool_Not_Initialized
    
    val, err_st := stack_count(&self.stack)
    return val, err_st
}

PoolError :: enum {
    None = 0,
    Pool_Cannot_Be_Nil,
    Pool_Not_Initialized,
    Pool_Cap_Should_Be_Greater_Than_Zero,
    Pool_Cap_Should_Be_Larger_Than_Initial_Allocation_Value
}