const board = @import("../board.zig");

pub const ATTACK_TABLE: [64]board.Bitboard = init_attack_table();

const MOVES: [8]board.Move = [_]board.Move{ 15, 17, -15, -17, 6, 10, -6, -10 };

pub fn init_attack_table() [64]board.Bitboard {
    var table: [64]board.Bitboard = undefined;
    for (0..64) |idx| {
        table[idx] = generate_knight_moves(idx);
    }
    return table;
}

pub fn generate_knight_moves(square: board.Square) board.Bitboard {
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

            if (@abs(row - new_row) <= 2 and @abs(col - new_col) <= 2) {
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
