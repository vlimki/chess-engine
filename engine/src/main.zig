const std = @import("std");
const util = @import("util.zig");
const board = @import("board.zig");
const move_gen = @import("move_gen/module.zig");

pub fn main() void {
    var b = board.Board.from_fen(board.STARTING_BOARD[0..]);

    // board.bitboard_debug(b.white.pawn);
    // board.bitboard_debug(b.black.pawn);
    // board.bitboard_debug(b.white.king | b.black.king);
    // board.bitboard_debug(b.white.rook | b.white.knight);
    // board.bitboard_debug(move_gen.ATTACK_TABLE_KNIGHT[6]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_BLACK_QUEEN[62]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_BLACK_KING[62]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_WHITE_PAWN[54]);
    board.bitboard_debug(move_gen.ATTACK_TABLE_BLACK_BISHOP[62]);
    board.bitboard_debug(b.legal_moves(move_gen.ATTACK_TABLE_WHITE_BISHOP[2], board.Color.white));
    //board.bitboard_move_piece(&b.white.pawn, 11, 11 + 16);
    board.bitboard_debug(b.pieces(board.Color.white));
    board.bitboard_debug(move_gen.bishop.legal_moves(18, board.Color.white, b));
    board.bitboard_debug(move_gen.ATTACK_TABLE_WHITE_BISHOP[18]);
}
