const std = @import("std");

pub fn reverse(input: []const u8) [64]u8 {
    var output: [64]u8 = [_]u8{'0'} ** 64;

    for (input, 0..) |c, i| {
        output[input.len - 1 - i] = c;
    }

    return output;
}

pub fn col(square: u6) u6 {
    return square % 8;
}

pub fn row(square: u6) u6 {
    return @divFloor(square, 8);
}

pub fn split(allocator: *std.mem.Allocator, input: []const u8, n: usize) []const []const u8 {
    const length = (input.len + n - 1) / n;
    var parts = allocator.alloc([]const u8, length) catch return undefined;

    var i: usize = 0;
    while (i < length) {
        const start = i * n;
        const end = start + n;
        parts[i] = input[start..end];
        i += 1;
    }
    std.debug.print("{s}\n", .{parts});
    return parts;
}
