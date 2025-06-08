package datatypes

import "base:runtime"

Error :: union {
    RegistryError,
    PoolError,
    StackError,
    QueueError,
    runtime.Allocator_Error
}