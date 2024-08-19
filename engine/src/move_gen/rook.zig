const board = @import("../board.zig");
const std = @import("std");

pub const ATTACK_TABLE_WHITE: [64]board.Bitboard = init_attack_table_white();
pub const ATTACK_TABLE_BLACK: [64]board.Bitboard = init_attack_table_black();
pub const DIRECTIONS: [4]i8 = [4]i8{ 1, -1, 8, -8 };

pub fn init_attack_table_white() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_rook_moves(idx);
    }
    return table;
}

pub fn init_attack_table_black() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_rook_moves(idx);
    }
    return table;
}

pub fn generate_rook_moves(square: board.Square) board.Bitboard {
    @setEvalBranchQuota(10000);
    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (DIRECTIONS) |d| {
        var i: i8 = 1;
        while (true) {
            const new_square: i8 = @as(i8, square) + i * d;
            const row = new_square / 8;
            const col = @rem(new_square, 8);

            if (new_square < 64 and new_square >= 0) {
                if (new_square != square) {
                    attacks |= (one << new_square);
                }
            } else {
                break;
            }

            i += 1;

            if ((row == 7 and d > 0) or (col == 7 and d > 0) or (col == 0 and d < 0) or (row == 0 and d < 0)) {
                break;
            }
        }
    }

    return attacks;
}

pub fn legal_moves(square: board.Square, color: board.Color, b: board.Board) board.Bitboard {
    @setEvalBranchQuota(10000);
    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (DIRECTIONS) |d| {
        var i: i8 = 1;
        while (true) {
            const new_square: i8 = @as(i8, square) + i * d;
            const row = @divFloor(new_square, 8);
            const col = @rem(new_square, 8);

            i += 1;
            if (new_square < 64 and new_square >= 0) {
                if (new_square != square) {
                    if (b.pieces(color) & (one << @intCast(new_square)) == 0) {
                        attacks |= (one << @intCast(new_square));
                        if (b.pieces(board.opponent_color(color)) & (one << @intCast(new_square)) != 0) {
                            break;
                        }
                    } else {
                        break;
                    }
                }
                if ((row == 7 and d > 0) or (col == 7 and d > 0) or (col == 0 and d < 0) or (row == 0 and d < 0)) {
                    break;
                }
            } else {
                break;
            }
        }
    }

    return attacks;
}
