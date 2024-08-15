const mn = @import("knight.zig");
const mb = @import("bishop.zig");
const mq = @import("queen.zig");
const mk = @import("king.zig");

pub const ATTACK_TABLE_KNIGHT = mn.ATTACK_TABLE;
pub const ATTACK_TABLE_QUEEN = mq.ATTACK_TABLE;
pub const ATTACK_TABLE_KING = mk.ATTACK_TABLE;
pub const ATTACK_TABLE_BISHOP = mb.ATTACK_TABLE;
