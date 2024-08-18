const mn = @import("knight.zig");
const mb = @import("bishop.zig");
const mq = @import("queen.zig");
const mk = @import("king.zig");
const mr = @import("rook.zig");
const mp = @import("pawn.zig");

pub const ATTACK_TABLE_WHITE_KNIGHT = mn.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_KNIGHT = mn.ATTACK_TABLE_BLACK;

pub const ATTACK_TABLE_WHITE_QUEEN = mq.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_QUEEN = mq.ATTACK_TABLE_BLACK;

pub const ATTACK_TABLE_WHITE_KING = mk.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_KING = mk.ATTACK_TABLE_BLACK;

pub const ATTACK_TABLE_WHITE_BISHOP = mb.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_BISHOP = mb.ATTACK_TABLE_BLACK;

pub const ATTACK_TABLE_WHITE_ROOK = mr.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_ROOK = mr.ATTACK_TABLE_BLACK;

pub const ATTACK_TABLE_WHITE_PAWN = mp.ATTACK_TABLE_WHITE;
pub const ATTACK_TABLE_BLACK_PAWN = mp.ATTACK_TABLE_BLACK;
