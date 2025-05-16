package datatypes

import "base:runtime"

Error :: union {
    RegistryError,
    PoolError,
    StackError,
    runtime.Allocator_Error
}