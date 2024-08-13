//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");

const Bitboard = u64;
const FEN = []u8;

const STARTING_BOARD = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

const Pieces = struct {
    pawn: Bitboard,
    bishop: Bitboard,
    knight: Bitboard,
    rook: Bitboard,
    queen: Bitboard,
    king: Bitboard,

    pub fn empty() Pieces {
        return Pieces{ .pawn = 0, .bishop = 0, .knight = 0, .rook = 0, .queen = 0, .king = 0 };
    }
};

pub fn bitboard_insert_piece(self: *Bitboard, pos: u6) void {
    const one: u64 = @as(u64, 1);
    self.* |= one << @intCast(pos);
}

fn debug_bitboard(bitboard: u64) void {
    var result: [64]u8 = [_]u8{'0'} ** 64;

    var i: usize = 0;
    const one: u64 = 1;
    while (i < 64) : (i += 1) {
        if ((bitboard & (one << @intCast(i))) != 0) {
            result[63 - i] = '1';
        }
    }

    std.debug.print("{s}\n", .{result});
}

const Board = struct {
    black: Pieces,
    white: Pieces,

    pub fn empty() Board {
        return Board{ .black = Pieces.empty(), .white = Pieces.empty() };
    }

    pub fn print(self: Board) void {
        debug_bitboard(self.black.king | self.black.queen | self.black.rook | self.black.knight | self.black.bishop | self.black.pawn | self.white.king | self.white.queen | self.white.rook | self.white.knight | self.white.bishop | self.white.pawn);
    }

    pub fn insert_piece(self: *Board, c: u8, pos: u6) void {
        const piece: *Bitboard = switch (c) {
            'K' => &self.white.king,
            'Q' => &self.white.queen,
            'R' => &self.white.rook,
            'B' => &self.white.bishop,
            'N' => &self.white.knight,
            'P' => &self.white.pawn,
            'k' => &self.black.king,
            'q' => &self.black.queen,
            'r' => &self.black.rook,
            'b' => &self.black.bishop,
            'n' => &self.black.knight,
            'p' => &self.black.pawn,
            else => return,
        };
        bitboard_insert_piece(piece, pos);
    }

    pub fn from_fen(fen: []const u8) Board {
        var pos: u64 = 0;

        var b = Board.empty();

        for (fen) |c| {
            switch (c) {
                '1'...'8' => pos += @intCast(c - '0'),
                '/' => continue,
                ' ' => break,
                else => {
                    b.insert_piece(c, @intCast(pos));
                    pos += 1;
                },
            }
        }

        return b;
    }
};

pub fn main() void {
    const b = Board.from_fen(STARTING_BOARD[0..]);
    debug_bitboard(b.white.pawn);
    debug_bitboard(b.black.pawn);
    debug_bitboard(b.white.queen);
    b.print();
}
