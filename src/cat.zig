const std = @import("std");

const BUF_SIZE = 1 << 14;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var args = std.process.args();
    defer args.deinit();
    const process = args.next().?;

    // Create a fifo pipe with buffer size 65536
    var fifo = std.fifo.LinearFifo(u8, .{ .Static = BUF_SIZE }).init();

    while (args.next()) |filename| {
        const file = if (std.mem.eql(u8, filename, "-"))
            std.io.getStdIn()
        else
            std.fs.cwd().openFile(filename, .{}) catch |err| {
                std.debug.print("{s}: '{s}': {}\n", .{ process, filename, err });
                continue;
            };

        try fifo.pump(file.reader(), stdout);
    }
}
