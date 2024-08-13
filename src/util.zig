const std = @import("std");

pub fn reverse(input: []const u8, allocator: *std.mem.Allocator) []u8 {
    var output = allocator.alloc(u8, input.len) catch return &[_]u8{};

    for (input, 0..) |c, i| {
        output[input.len - 1 - i] = c;
    }

    return output;
}
