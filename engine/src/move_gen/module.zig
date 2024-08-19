pub const knight = @import("knight.zig");
pub const bishop = @import("bishop.zig");
pub const queen = @import("queen.zig");
pub const king = @import("king.zig");
pub const rook = @import("rook.zig");
pub const pawn = @import("pawn.zig");

pub const AttackTable = [64]u64;

pub const ATTACK_TABLE_WHITE_KNIGHT = knight.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_KNIGHT = knight.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_KNIGHT = knight.DIRECTIONS;

pub const ATTACK_TABLE_WHITE_QUEEN = queen.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_QUEEN = queen.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_QUEEN = queen.DIRECTIONS;

pub const ATTACK_TABLE_WHITE_KING = king.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_KING = king.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_KING = king.DIRECTIONS;

pub const ATTACK_TABLE_WHITE_BISHOP = bishop.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_BISHOP = bishop.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_BISHOP = bishop.DIRECTIONS;

pub const ATTACK_TABLE_WHITE_ROOK = rook.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_ROOK = rook.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_ROOK = rook.DIRECTIONS;

pub const ATTACK_TABLE_WHITE_PAWN = pawn.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_PAWN = pawn.ATTACK_TABLE_BLACK;
pub const DIRECTIONS_PAWN = pawn.DIRECTIONS;
