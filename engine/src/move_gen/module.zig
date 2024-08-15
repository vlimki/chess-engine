const mk = @import("knight.zig");
const mb = @import("bishop.zig");
const mq = @import("queen.zig");

pub const ATTACK_TABLE_KNIGHT = mk.ATTACK_TABLE;
pub const ATTACK_TABLE_QUEEN = mq.ATTACK_TABLE;
pub const ATTACK_TABLE_BISHOP = mb.ATTACK_TABLE;
