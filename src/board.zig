const std = @import("std");
const util = @import("util.zig");

pub const Bitboard = u64;
pub const Square = u6;
pub const Move = i7;

const FEN = []u8;

pub const STARTING_BOARD = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

pub const Pieces = struct {
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

pub fn debug_bitboard(bitboard: u64) void {
    const one: u64 = 1;

    var s = [1]u8{'0'} ** 64;

    var idx: usize = 0;
    while (idx <= 63) : (idx += 1) {
        if (bitboard & (one << @intCast(idx)) != 0) {
            s[idx] = '1';
        }
    }

    var allocator = std.heap.page_allocator;
    const rows = util.split(&allocator, &s, 8);

    var i: usize = rows.len;

    while (i > 0) : (i -= 1) {
        for (rows[i - 1]) |c| {
            std.debug.print("{c}  ", .{c});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("----------------\n", .{});
}

pub const Board = struct {
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
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();

        const newFen = fen[0..fen.len];

        var pos: u64 = 0;

        var b = Board.empty();

        var boardFenIter = std.mem.splitSequence(u8, newFen, " ");
        const boardFen = boardFenIter.next().?;

        var rows = std.mem.splitBackwardsSequence(u8, boardFen, "/");

        while (rows.next()) |row| {
            for (row) |c| {
                switch (c) {
                    '1'...'8' => pos += @intCast(c - '0'),
                    else => {
                        b.insert_piece(c, @intCast(pos));
                        // std.debug.print("{}, {c}\n", .{ pos, c });
                        // std.debug.print("Inserted piece {c} at {}\n", .{ c, pos });

                        if (pos < 63) {
                            pos += 1;
                        }
                    },
                }
            }
        }

        return b;
    }
};
