const board = @import("../board.zig");

pub const ATTACK_TABLE: [64]board.Bitboard = init_attack_table();

const MOVES: [28]board.Move = [_]board.Move{
    9,
    18,
    27,
    36,
    45,
    54,
    63,
    -9,
    -18,
    -27,
    -36,
    -45,
    -54,
    -63,
    7,
    14,
    21,
    28,
    35,
    42,
    49,
    -7,
    -14,
    -21,
    -28,
    -35,
    -42,
    -49,
};

pub fn init_attack_table() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_bishop_moves(idx);
    }
    return table;
}

pub fn generate_bishop_moves(square: board.Square) board.Bitboard {
    @setEvalBranchQuota(10000);
    const row = square / 8;
    const col = @rem(square, 8);
    const one: u64 = @as(u64, 1);
    const board_max: i8 = 64;

    var attacks: board.Bitboard = 0;

    for (MOVES) |move| {
        if (board_max - move - @as(i8, square) > 0 and square + move < 64) {
            const new_square = square + move;
            const new_row = @divFloor(new_square, 8);
            const new_col = @rem(new_square, 8);

            if (!(new_col == col or new_row == row) and new_square > 0 and new_square < 64 and (@abs(new_row - row) == @abs(new_col - col))) {
                if (new_square > 0) {
                    attacks |= (one << @intCast(new_square));
                } else {
                    attacks |= (one >> @intCast(@abs(new_square)));
                }
            }
        }
    }

    return attacks;
}
