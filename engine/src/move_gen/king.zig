const board = @import("../board.zig");

pub const ATTACK_TABLE: [64]board.Bitboard = init_attack_table();

pub fn init_attack_table() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_king_moves(idx);
    }
    return table;
}

pub fn generate_king_moves(square: board.Square) board.Bitboard {
    const directions: [8]i8 = [8]i8{ 1, -1, 7, -7, 8, -8, 9, -9 };
    @setEvalBranchQuota(10000);

    const row = square / 8;
    const col = @rem(square, 8);

    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (directions) |d| {
        const new_square: i8 = @as(i8, square) + d;
        const new_row = new_square / 8;
        const new_col = @rem(new_square, 8);

        if (new_square < 64 and new_square >= 0 and (@abs(new_row - row) <= 1 and @abs(new_col - col) <= 1)) {
            attacks |= (one << new_square);
        }
    }

    return attacks;
}
