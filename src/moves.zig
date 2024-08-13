const board = @import("board.zig");

const KNIGHT_MOVES: [8]board.Move = [_]board.Move{ 15, 17, -15, -17, 6, 10, -6, -10 };

pub fn generate_knight_moves(square: board.Square) board.Bitboard {
    const row = square / 8;
    const col = @rem(square, 8);
    const one: u64 = @as(u64, 1);

    var attacks: board.Bitboard = 0;

    for (KNIGHT_MOVES) |move| {
        if (square < move and 63 - @abs(move) - square > 0) {
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
