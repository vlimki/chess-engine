const board = @import("../board.zig");
const bishop = @import("bishop.zig");
const rook = @import("rook.zig");

pub const ATTACK_TABLE_WHITE: [64]board.Bitboard = init_attack_table_white();
pub const ATTACK_TABLE_BLACK: [64]board.Bitboard = init_attack_table_black();
pub const DIRECTIONS: [8]i8 = [8]i8{ 1, -1, 7, -7, 8, -8, 9, -9 };

pub fn init_attack_table_white() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_queen_moves(idx);
    }
    return table;
}

pub fn init_attack_table_black() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_queen_moves(idx);
    }
    return table;
}

pub fn generate_queen_moves(square: board.Square) board.Bitboard {
    @setEvalBranchQuota(10000);
    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (DIRECTIONS) |d| {
        var i: i8 = 1;
        while (true) {
            const new_square: i8 = @as(i8, square) + i * d;
            const row = new_square / 8;
            const col = @rem(new_square, 8);

            i += 1;
            if (new_square < 64 and new_square >= 0) {
                if (new_square != square) {
                    attacks |= (one << new_square);
                }
            } else {
                break;
            }

            if ((row == 7 and d > 0) or (col == 7 and d > 0) or (col == 0 and d < 0) or (row == 0 and d < 0)) {
                break;
            }
        }
    }

    return attacks;
}

pub fn legal_moves(square: board.Square, color: board.Color, b: board.Board) board.Bitboard {
    @setEvalBranchQuota(10000);
    return bishop.legal_moves(square, color, b) | rook.legal_moves(square, color, b);
}
