const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var args = std.process.args();
    defer args.deinit();
    _ = args.skip();
    while (args.next()) |filename| {
        const file = if (std.mem.eql(u8, filename, "-"))
            std.io.getStdIn()
        else
            try std.fs.cwd().openFile(filename, .{});

        // Create a fifo pipe with buffer size 65536
        var fifo = std.fifo.LinearFifo(u8, .{ .Static = 65536 }).init();
        try fifo.pump(file.reader(), stdout);
    }
}
