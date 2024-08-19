const board = @import("../board.zig");
const std = @import("std");

pub const ATTACK_TABLE_WHITE: [64]board.Bitboard = init_attack_table_white();
pub const ATTACK_TABLE_BLACK: [64]board.Bitboard = init_attack_table_black();
pub const DIRECTIONS: [4]i8 = [4]i8{ 8, 16, 7, 9 };

pub fn init_attack_table_white() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_pawn_moves(idx, board.Color.white);
    }
    return table;
}

pub fn init_attack_table_black() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_pawn_moves(idx, board.Color.black);
    }
    return table;
}

pub fn generate_pawn_moves(square: board.Square, color: board.Color) board.Bitboard {
    @setEvalBranchQuota(1000);

    const row = square / 8;
    const col = @rem(square, 8);

    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (DIRECTIONS) |d| {
        const new_square: i8 = if (color == board.Color.white) @as(i8, square) + d else @as(i8, square) - d;
        const new_row = new_square / 8;
        const new_col = @rem(new_square, 8);

        if (new_square < 64 and new_square >= 0 and d == 16 and ((color == board.Color.white and col == 1) or (color == board.Color.black and col == 6))) {
            attacks |= (one << new_square);
        }

        if (new_square < 64 and new_square >= 0 and (@abs(new_row - row) <= 1 and @abs(new_col - col) <= 1) and d != 16) {
            attacks |= (one << new_square);
        }
    }

    return attacks;
}
