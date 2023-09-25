---@class Queue<T> : {data: table<number, T>, left: number, right: number}
Queue = {}
function Queue.new()
    return {
        data = {},
        left = 1,
        right = 1
    }
end

---comment
---@generic T
---@param queue Queue<T>
---@return T
function Queue.pop(queue)
    local item = queue.data[queue.left]
    queue.left = queue.left + 1
    return item
end

---@generic T
---@param queue Queue<T>
---@param item T
function Queue.push(queue, item)
    queue.data[queue.right] = item
    queue.right = queue.right + 1
end

---@generic T
---@param queue Queue<T>
---@return T
function Queue.peek(queue)
    return queue.data[queue.left]
end

function Queue.length(queue)
    return queue.right - queue.left
end

return Queue