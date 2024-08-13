const std = @import("std");
const util = @import("util.zig");
const board = @import("board.zig");
const moves = @import("moves.zig");

pub fn main() void {
    var b = board.Board.from_fen(board.STARTING_BOARD[0..]);

    board.bitboard_debug(b.white.pawn);
    board.bitboard_debug(b.black.pawn);
    board.bitboard_debug(b.white.king | b.black.king);
    board.bitboard_debug(b.white.rook | b.white.knight);
    board.bitboard_debug(moves.generate_knight_moves(6));
    board.bitboard_debug(moves.generate_bishop_moves(57));
    b.print();
    board.bitboard_move_piece(&b.white.pawn, 12, 28);
    b.print();
}
