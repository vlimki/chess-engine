const board = @import("board.zig");
const std = @import("std");

const MOVES_KNIGHT: [8]board.Move = [_]board.Move{ 15, 17, -15, -17, 6, 10, -6, -10 };
const MOVES_PAWN_BLACK: [4]board.Move = [_]board.Move{ -8, -7, -9, -16 };
const MOVES_PAWN_WHITE: [4]board.Move = [_]board.Move{ 8, 7, 9, 16 };
const MOVES_BISHOP: [28]board.Move = [_]board.Move{
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

pub fn generate_knight_moves(square: board.Square) board.Bitboard {
    const row = square / 8;
    const col = @rem(square, 8);
    const one: u64 = @as(u64, 1);
    const board_max: i8 = 64;

    var attacks: board.Bitboard = 0;

    for (MOVES_KNIGHT) |move| {
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

pub fn generate_bishop_moves(square: board.Square) board.Bitboard {
    const row = square / 8;
    const col = @rem(square, 8);
    const one: u64 = @as(u64, 1);
    const board_max: i8 = 64;

    var attacks: board.Bitboard = 0;

    for (MOVES_BISHOP) |move| {
        if (board_max - move - @as(i8, square) > 0 and square + move < 64) {
            const new_square = square + move;
            const new_row = @divFloor(new_square, 8);
            const new_col = @rem(new_square, 8);

            if (!(new_col == col or new_row == row) and new_square > 0 and new_square < 64 and (@abs(@divFloor(new_square, 8) - row) == @abs(@rem(new_square, 8) - col))) {
                std.debug.print("Found move at {} for square {} ({})\n", .{ move, square, new_square });
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
