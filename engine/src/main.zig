const std = @import("std");
const util = @import("util.zig");
const board = @import("board.zig");
const move_gen = @import("move_gen/module.zig");

pub fn main() void {
    var b = board.Board.from_fen(board.STARTING_BOARD[0..]);

    board.bitboard_move_piece(&b.white.pawn, 12, 12 + 16);
    board.bitboard_debug(b.pieces(board.Color.white) | b.pieces(board.Color.black));
    std.debug.print("{d}", .{b.eval()});
}
