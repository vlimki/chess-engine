const board = @import("../board.zig");

pub const ATTACK_TABLE: [64]board.Bitboard = init_attack_table();

pub fn init_attack_table() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_bishop_moves(idx);
    }
    return table;
}

pub fn generate_bishop_moves(square: board.Square) board.Bitboard {
    const directions: [4]i8 = [4]i8{ 7, -7, 9, -9 };
    @setEvalBranchQuota(10000);
    const one: u64 = @as(u64, 1);

    const row = square / 8;
    const col = @rem(square, 8);

    var attacks: board.Bitboard = 0;

    for (directions) |d| {
        var i: i8 = 1;
        while (true) {
            const new_square: i8 = @as(i8, square) + i * d;
            const new_row = new_square / 8;
            const new_col = @rem(new_square, 8);

            i += 1;
            if (new_square < 64 and new_square >= 0 and @abs(new_row - row) == @abs(new_col - col)) {
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
