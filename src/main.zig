const std = @import("std");
const util = @import("util.zig");
const board = @import("board.zig");
const moves = @import("moves.zig");

pub fn main() void {
    const b = board.Board.from_fen(board.STARTING_BOARD[0..]);

    board.debug_bitboard(b.white.pawn);
    board.debug_bitboard(b.black.pawn);
    board.debug_bitboard(b.white.king | b.black.king);
    board.debug_bitboard(b.white.rook | b.white.knight);
    b.print();
    board.debug_bitboard(moves.generate_knight_moves(6));
    board.debug_bitboard(moves.generate_bishop_moves(57));
}
