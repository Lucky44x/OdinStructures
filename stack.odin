package datatypes

Stack :: struct($T: typeid, $cap: int) {
    elements: [cap]T,
    idx: int,
    initialized: bool
}

/*
Initializes the Stack
*/
stack_init :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return StackError.Stack_Cannot_Be_Nil
    if self.initialized do return StackError.Stack_Already_Initialized

    //This is the only thing we REALLY have to do, we could also just kick this function completely...
    self.idx = 0
    self.initialized = true
    return nil
}

/*
Pushes the provided Value onto the top of the Stack
*/
stack_push :: proc(
    self: ^Stack($T, $cap),
    val: T,
    loc := #caller_location
) -> Error {
    if self == nil do return StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return StackError.Stack_Not_Initialized

    if self.idx == cap do return StackError.Stack_Overflow

    self.elements[self.idx] = val
    self.idx += 1
    return nil
}

/*
Pops the top value off the stack and returns it
*/
stack_pop :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> (val: T, err: Error) {
    if self == nil do return {}, StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return {}, StackError.Stack_Not_Initialized
    
    //Might be a bit controversial returning an error in this case, but I consider this an error condition, since I specifically provide a is_empty function
    if self.idx == 0 do return {}, StackError.Stack_Empty

    self.idx -= 1
    return self.elements[self.idx], nil
}

/*
Clears the stack
*/
stack_clear :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return StackError.Stack_Not_Initialized

    self.idx = 0
    return nil
}

/*
Returns true when the Stack is empty
*/
stack_is_empty :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> (n: bool, err: Error) {
    if self == nil do return false, StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return false, StackError.Stack_Not_Initialized

    return self.idx == 0, nil
}

/*
Returns true when the Stack is full
*/
stack_is_full :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> (n: bool, err: Error) {
    if self == nil do return false, StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return false, StackError.Stack_Not_Initialized

    return self.idx == cap, nil
}

/*
Returns the size of the Stack
*/
stack_count :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> (n: int, err: Error) {
    if self == nil do return 0, StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return 0, StackError.Stack_Not_Initialized

    //if self.idx == 0 do return 0, StackError.Stack_Empty

    return self.idx, nil
}

/*
Returns the length (max size) of the stack
*/
stack_len :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> (n: int, err: Error) {
    if self == nil do return 0, StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return 0, StackError.Stack_Not_Initialized

    return cap, nil
}

/*
Destroys the provided Stack
*/
stack_destroy :: proc(
    self: ^Stack($T, $cap),
    loc := #caller_location
) -> Error {
    if self == nil do return StackError.Stack_Cannot_Be_Nil
    if !self.initialized do return StackError.Stack_Not_Initialized

    //Noop, but still implemented for completeness-sake

    return nil
}

StackError :: enum {
    Stack_Cannot_Be_Nil,
    Stack_Not_Initialized,
    Stack_Already_Initialized,
    Stack_Empty,
    Stack_Overflow
}