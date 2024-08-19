const std = @import("std");
const util = @import("util.zig");
const move_gen = @import("move_gen/module.zig");

pub const Bitboard = u64;
pub const Square = u6;
pub const Move = i8;

pub const Color = enum { white, black };

pub fn opponent_color(own: Color) Color {
    return if (own == Color.white) Color.black else Color.white;
}

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

pub fn bitboard_squares(self: *const Bitboard) []Square {
    const allocator = std.heap.page_allocator;
    var squares = std.ArrayList(Square).init(allocator);

    const one: u64 = @as(u64, 1);
    var i: u6 = 0;

    while (i < 64) : (i += 1) {
        if (self.* & (one << i) != 0) {
            squares.append(i) catch return &[0]Square{};
        }
        if (i == 63) {
            break;
        }
    }

    return squares.items;
}

pub fn bitboard_move_piece(self: *Bitboard, src: Square, dst: Square) void {
    const one: u64 = 1;
    self.* ^= (one << src);
    self.* |= (one << dst);
}

pub fn bitboard_debug(bitboard: u64) void {
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

    pub fn legal_moves(self: Board, moves: Bitboard, color: Color) Bitboard {
        const ownPieces = self.pieces(color);
        return (moves & (~ownPieces));
    }

    // What is this disgusting code
    pub fn eval(self: Board) f32 {
        return 100 * @as(f32, @floatFromInt(@popCount(self.white.king))) - 100 * @as(f32, @floatFromInt(@popCount(self.black.king))) + 9 * @as(f32, @floatFromInt(@popCount(self.white.queen))) - 9 * @as(f32, @floatFromInt(@popCount(self.black.queen))) + 5 * @as(f32, @floatFromInt(@popCount(self.white.rook))) - 5 * @as(f32, @floatFromInt(@popCount(self.black.rook))) + 3 * @as(f32, @floatFromInt(@popCount(self.white.bishop))) - 3 * @as(f32, @floatFromInt(@popCount(self.black.bishop))) + 3 * @as(f32, @floatFromInt(@popCount(self.white.knight))) - 3 * @as(f32, @floatFromInt(@popCount(self.black.knight))) + 1 * @as(f32, @floatFromInt(@popCount(self.white.pawn))) - 1 * @as(f32, @floatFromInt(@popCount(self.black.pawn))) + 0.1 * @as(f32, @floatFromInt(n_legal_moves(self, Color.white))) - 0.1 * @as(f32, @floatFromInt(n_legal_moves(self, Color.black)));
    }

    // What is this disgusting code
    pub fn n_legal_moves(self: Board, color: Color) i16 {
        var moves: i16 = 0;

        switch (color) {
            Color.white => {
                for (bitboard_squares(&self.white.queen)) |sq| {
                    moves += @popCount(move_gen.queen.legal_moves(sq, color, self));
                }
                for (bitboard_squares(&self.white.bishop)) |sq| {
                    moves += @popCount(move_gen.bishop.legal_moves(sq, color, self));
                }
                for (bitboard_squares(&self.white.rook)) |sq| {
                    moves += @popCount(move_gen.rook.legal_moves(sq, color, self));
                }
                return moves;
            },
            Color.black => {
                for (bitboard_squares(&self.black.queen)) |sq| {
                    moves += @popCount(move_gen.queen.legal_moves(sq, color, self));
                }
                for (bitboard_squares(&self.black.bishop)) |sq| {
                    moves += @popCount(move_gen.bishop.legal_moves(sq, color, self));
                }
                for (bitboard_squares(&self.black.rook)) |sq| {
                    moves += @popCount(move_gen.rook.legal_moves(sq, color, self));
                }
                return moves;
            },
        }

        return moves;
    }

    pub fn pieces(self: Board, color: Color) Bitboard {
        return switch (color) {
            Color.white => self.white.king | self.white.queen | self.white.rook | self.white.bishop | self.white.knight | self.white.pawn,
            Color.black => self.black.king | self.black.queen | self.black.rook | self.black.bishop | self.black.knight | self.black.pawn,
        };
    }

    pub fn print(self: Board) void {
        bitboard_debug(self.black.king | self.black.queen | self.black.rook | self.black.knight | self.black.bishop | self.black.pawn | self.white.king | self.white.queen | self.white.rook | self.white.knight | self.white.bishop | self.white.pawn);
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
