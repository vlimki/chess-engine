const std = @import("std");
const util = @import("util.zig");
const board = @import("board.zig");
const move_gen = @import("move_gen/module.zig");

pub fn main() void {
    // var b = board.Board.from_fen(board.STARTING_BOARD[0..]);

    // board.bitboard_debug(b.white.pawn);
    // board.bitboard_debug(b.black.pawn);
    // board.bitboard_debug(b.white.king | b.black.king);
    // board.bitboard_debug(b.white.rook | b.white.knight);
    // board.bitboard_debug(move_gen.ATTACK_TABLE_KNIGHT[6]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_BISHOP[6]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_QUEEN[25]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_KING[25]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_ROOK[25]);
    // b.print();
    // board.bitboard_move_piece(&b.white.pawn, 12, 28);
    // b.print();
}
